nnoremap <leader>gw :silent execute "grep! -R " . shellescape("<cWORD>") . " ."<cr>:copen<cr>
nnoremap <leader>g :set operatorfunc=<SID>Grep<cr>g@
vnoremap <leader>g :<c-u>call <SID>Grep(visualmode())<cr>

function! s:Grep(type)
    let saved_at = @@
    if a:type ==# 'v'
        execute "normal! `<v`>y"
    elseif a:type ==# 'char'
        execute "normal! `[v`]y"
    else
        return
    endif

    silent execute "grep! -R " . shellescape(@@) . " ."
    let @@ = saved_at

    copen
endfunction
