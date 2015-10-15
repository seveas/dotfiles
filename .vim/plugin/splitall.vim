" Forgot to use -O when opening more than one file? This lets you split
" afterwards with <leader>s

function! SplitAll()
    let buf = bufnr("$")
    " Iterate over all buffers, open invisible ones with split
    while buf
        if bufexists(buf) && (bufwinnr(buf) == -1)
            execute "rightbelow split " . bufname(buf)
        endif
        let buf = buf - 1
    endwhile
endfunction
nnoremap <leader>s :call SplitAll()<cr>
