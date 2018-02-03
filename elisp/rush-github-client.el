(require 'url)

(defconst rush-github-url "https://api.github.com")

(defconst rush-personal-token-location "~/.rush/personal-token")

(defconst rush-default-request-headers '(("Acept" . "application/vnd.github.v3+json")
                                         ("User-Agent" . "emacs-gist")))

(defun rush-print-data (data)
  (with-output-to-temp-buffer "*Github Response*"
    (print data)))

(defun rush-handle-response (f status)
  (goto-char (point-min))
  (re-search-forward "^$")
  (let ((data   (json-read)))
    (kill-buffer (current-buffer))
    (funcall f data)))

(defun rush-read-personal-token ()
  (with-temp-buffer
    (insert-file-contents rush-personal-token-location)
    (buffer-string)))

(defun rush-assemble-headers ()
  (cons (cons "Authorization" (concat "token " (rush-read-personal-token)))
        rush-default-request-headers))

(defun rush-assemble-query (params)
  (mapconcat (lambda (pair)
               (concat (url-hexify-string (car pair))
                       "="
                       (url-hexify-string                        (cdr pair))))
             params "&"))

(defun rush-assemble-url (&rest args)
  (concat (or (plist-get args :url) (concat rush-github-url (plist-get args :path)))
          "?"
          (rush-assemble-query (plist-get args :query))))

(defun rush-request (&rest args)
  (let* ((url-request-method (or (plist-get args :method) "GET"))
         (url (apply 'rush-assemble-url args))
         (url-request-extra-headers (rush-assemble-headers))
         (success-function (or (plist-get args :success-function) 'rush-print-data)))
    (url-retrieve url (apply-partially 'rush-handle-response success-function))))

(provide 'rush-github-client)
