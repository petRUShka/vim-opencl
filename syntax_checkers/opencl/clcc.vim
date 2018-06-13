"============================================================================
"File:        clcc.vim
"Description: OpenCL syntax checking plugin for syntastic.vim
"Maintainer:  petRUShka <petrushkin at yandex dot ru>
"License:     GPLv3
"
"============================================================================

if exists('g:loaded_syntastic_opencl_clcc_checker')
    finish
endif
let g:loaded_syntastic_opencl_clcc_checker = 1

let s:save_cpo = &cpo
set cpo&vim

if exists('g:syntastic_extra_filetypes')
    call add(g:syntastic_extra_filetypes, 'opencl')
else
    let g:syntastic_extra_filetypes = ['opencl']
endif

function! SyntaxCheckers_opencl_clcc_GetLocList() dict
    let makeprg = self.makeprgBuild({})

    " Intel beignet format
    let errorformat  =
        \ '%E%f:%l:%c: error: %m,%-Z,'.
        \ '%W%f:%l:%c: warning: %m,%-Z,'
    " pocl format
    let errorformat .=
        \ '%Eerror: %.%#:%l:%c: %m,%-Z,'
    " NVIDIA driver format
    let errorformat .=
        \ '%E:%l:%c: error: %m,%-Z%p^\[ ~\]%#,'.
        \ '%W:%l:%c: warning: %m,%-Z%p^\[ ~\]%#,'.
        \ '%I:%l:%c: note: %m,%-Z%p^\[ ~\]%#,'
    " AMD driver format
    let errorformat .=
        \ '%E"%f"\, line %l: catastrophic error: %m,%+C%.%#,%-Z%p^,'.
        \ '%E"%f"\, line %l: error: %m,%+C%.%#,%-Z%p^,'.
        \ '%W"%f"\, line %l: warning: %m,%-C%.%#,'
    " Other lines should be hidden
    let errorformat .=
        \ '%-G%.%#'

    return SyntasticMake({
        \ 'makeprg': makeprg,
        \ 'errorformat': errorformat,
        \ 'defaults': { 'bufnr': bufnr('') } })
endfunction

call g:SyntasticRegistry.CreateAndRegisterChecker({
    \ 'filetype': 'opencl',
    \ 'name': 'clcc' })

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: set sw=4 sts=4 et fdm=marker:
