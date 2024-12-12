function! OpenPuppetTemplate(tmpl)
    let template = expand(a:tmpl)
    let parts = split(template, "/")
    execute "leftabove split modules/" . parts[0] . "/templates/" . join(parts[1:], "/")
endfunction
nnoremap <leader>t :call OpenPuppetTemplate(expand('<cfile>'))<cr>

function! OpenPuppetFile(url)
    let url = substitute(a:url, "puppet:///modules/", "", "")
    let parts = split(url, "/")
    execute "leftabove split modules/" . parts[0] . "/files/" . join(parts[1:], "/")
endfunction
nnoremap <leader>f :call OpenPuppetFile(expand('<cfile>'))<cr>

function! OpenPuppetManifest(path)
    let parts = split(a:path, "::")
    if len(parts) == 1
        execute "leftabove split modules/" . parts[0] . "/manifests/init.pp"
    else
        execute "leftabove split modules/" . parts[0] . "/manifests/" . join(parts[1:], "/") . ".pp"
    endif
endfunction
nnoremap <leader>m :call OpenPuppetManifest(expand('<cWORD>'))<cr>
