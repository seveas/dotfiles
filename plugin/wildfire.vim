" =============================================================================
" File: wildfire.vim
" Description: Smart selection of the closest text object
" Mantainer: Giacomo Comitti (https://github.com/gcmt)
" Url: https://github.com/gcmt/wildfire.vim
" License: MIT
" =============================================================================


" Init
" =============================================================================

if exists("g:loaded_wildfire") || &cp
    finish
endif
let g:loaded_wildfire = 1


" Settings
" =============================================================================

let g:wildfire_objects =
    \ get(g:, "wildfire_objects", ["ip", "i)", "i]", "i}", "i'", 'i"', "it"])

let g:wildfire_fuel_map =
    \ get(g:, "wildfire_fuel_map", "<ENTER>")

let g:wildfire_water_map =
    \ get(g:, "wildfire_water_map", "<BS>")


" Functions
" =============================================================================

let s:objects = {}
let s:winners_history = []
let s:origin = []

fu! s:Init()
    let s:origin = getpos(".")
    let s:winners_history = []
    for object in g:wildfire_objects
        let s:objects[object] = 1
    endfor
endfu

fu! s:Start(repeat)
    cal s:Init()
    cal s:SelectBiggerBlock(a:repeat)
endfu

fu! s:Fuel(repeat)
   cal s:SelectBiggerBlock(a:repeat)
endfu

fu! s:Water()
    cal s:SelectSmallerBlock()
endfu

fu! s:SelectBiggerBlock(repeat)

    if !a:repeat
        return
    endif

    cal setpos(".", s:origin)

    let winview = winsaveview()

    let candidates = {}
    for object in keys(s:objects)

        let selection = "v" . s:objects[object] . object
        exe "sil! norm \<ESC>v\<ESC>" . selection . "\<ESC>"
        let [startline, startcol, endline, endcol] = s:get_visual_block_edges()

        cal winrestview(winview)

        " The selection failed with the candidate text object
        if startline == endline && startcol == endcol
            continue
        endif

        " Sometimes Vim selects text objects even if the cursor is outside the
        " them (e.g. `it`, `i"`, etc). We don't want this.
        let cursor_col = s:origin[2]
        if startline == endline && (cursor_col < startcol || cursor_col > endcol)
            continue
        endif

        let size = s:get_visual_block_size(startline, startcol, endline, endcol)

        " This happens when the count is incremented but the selection remains still
        if s:already_a_winner("v".(s:objects[object]-1).object, size)
            continue
        endif

        " Special case
        if object =~ "a\"\\|i\"\\|a'\\|i'" && startline == endline
            if s:already_a_winner("v".(s:objects[object]-1).object, size-2)
                continue
            endif
            let quote = strpart(object, 1)
            let [before, after] = [getline("'<")[:startcol-3], getline("'<")[endcol+1:]]
            if s:odd_quotes(quote, before) || s:odd_quotes(quote, after)
                continue
            endif
        endif

        let candidates[size] = selection

    endfor

    cal s:SelectBestBlock(candidates)

    cal s:SelectBiggerBlock(a:repeat-1)

endfu

fu! s:SelectSmallerBlock()
    cal setpos(".", s:origin)
    if len(s:winners_history) > 1
        let last_winner = remove(s:winners_history, -1)[0]
        let s:objects[matchstr(last_winner, "\\D\\+$")] -= 1
        exe "sil! norm \<ESC>" . get(s:winners_history, -1)[0]
    endif
endfu

fu! s:SelectBestBlock(candidates)
    if len(a:candidates)
        let minsize = min(keys(a:candidates))
        let winner = a:candidates[minsize]
        let [startcol, endcol] = [a:candidates[minsize], a:candidates[minsize]]
        let s:winners_history = add(s:winners_history, [winner, minsize])
        let s:objects[matchstr(winner, "\\D\\+$")] += 1
        exe "sil! norm \<ESC>" . winner
    elseif len(s:winners_history)
        " get stuck on the last selection
        exe "sil! norm \<ESC>" . get(s:winners_history, -1)[0]
    else
        " do nothing
        exe "sil! norm \<ESC>"
    endif
endfu


" Helpers
" =============================================================================

fu! s:already_a_winner(selection, size)
    for [selection, size] in s:winners_history
        if selection == a:selection && size == a:size
            return 1
        endif
    endfor
    return 0
endfu

fu! s:odd_quotes(quote, s)
    let n = 0
    for i in range(0, strlen(a:s))
        if a:s[i] == a:quote && !(i > 0 && a:s[i-1] == "\\")
            let n += 1
        endif
    endfor
    return n % 2 != 0
endfu

fu! s:get_visual_block_edges()
    return [line("'<"), col("'<"), line("'>"), col("'>")]
endfu

fu! s:get_visual_block_size(startline, startcol, endline, endcol)
    if a:startline == a:endline
        return strlen(strpart(getline("'<"), a:startcol, a:endcol-a:startcol+1))
    endif
    let size = strlen(strpart(getline("'<"), a:startcol))
    let size += strlen(strpart(getline("'>"), 0, a:endcol))
    let size += winwidth(0) * abs(a:startline - a:endline)  " good enough
    return size
endfu


" Commands and Mappings
" =============================================================================

exec "nnoremap <silent> " . g:wildfire_fuel_map . " :<C-U>call <SID>Start(v:count1)<CR>"
exec "vnoremap <silent> " . g:wildfire_fuel_map . " :<C-U>call <SID>Fuel(v:count1)<CR>"
exec "vnoremap <silent> " . g:wildfire_water_map . " :<C-U>call <SID>Water()<CR>"
