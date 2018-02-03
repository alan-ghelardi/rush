(defconst rush-origin-url-regex "^git@github\.com:\\(.*\\)/\\(.*\\)$")

(defun rush-run-git-command (command)
  (shell-command-to-string (concat "git " command)))

(defun rush-get-owner-and-repo ()
  (let ((url   (rush-run-git-command "remote get-url --all origin")))
    (and (string-match rush-origin-url-regex url)
         (list (match-string 1 url)
               (match-string 2 url)))))

(provide 'rush-git)
