"# vim:textwidth=0:foldmethod=marker:foldlevel=1:
"======================================================================

autocmd vimrcDependencies BufEnter * if !empty(gitbranch#name()) | setlocal undofile | endif

"$$ Command
command! GitrootWD execute 'lcd' <SID>gitRoot()
command! -nargs=* Gitdiff call <SID>gitDiffCmd(<f-args>)

"$$ Map

nnoremap <silent> <space>gv :Gitdiff %<CR>
nnoremap <silent> <space>ga :<C-u>call <SID>gitadd()<CR>


"$$ Functions

function s:gitadd() abort "{{{2
  if exists('b:gitbranch_path')
    let l:path = expand('%')
    update | call job_start('git add ' . l:path)
    echo 'staged ' . l:path
  endif
endfunction

function s:gitRoot() abort "{{{2
  try
    return substitute(b:gitbranch_path, '.git/HEAD', '', '')
  catch
    return ''
  endtry
endfunction

function s:gitDiffCmd(...) abort "{{{2
  let l:root = s:gitRoot()
  if l:root !=# ''
    let l:path = a:0 ? a:{a:0} : '%'
    let l:path = strpart(fnamemodify(expand(l:path), ':p'), len(l:root))
    let l:path = substitute(l:path, '\\', '/', 'g')
    let l:hash = (a:0 ==# '2') ? a:1 : ''
    let g:diff_translations = 0
    diffthis | rightbelow vnew [diff] | set bt=nofile | execute 'silent! r! git cat-file -p ' . l:hash . ':' . l:path | 0d_ | diffthis | wincmd p
  else
    echo 'not a git repository.'
  endif
  return ''
endfunction

