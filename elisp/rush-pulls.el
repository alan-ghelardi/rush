(require 'rush-git)
(require 'rush-github-client)
(require 'rush-helpers)

(defconst rush-pull-requests-path "/repos/%s/%s/pulls")

(defvar rush-filters-for-pull-requests '(("state" . "open")))

(defun rush-pull->entry (pull)
  (let ((title (cdr (assq 'title pull)))
        (number (cdr (assq 'number pull)))
        (state (cdr (assq 'state pull)))
        (author (cdr (assq 'user pull)))
        (date-time (cdr (assq 'created_at pull))))
    (concat title " #" (number-to-string number) " "
            (if (equal state "open") "opened" "")
            " by " (cdr (assq 'login author))
            (if (equal state "closed") "was merged" "")
            " at "
            (rush-format-date-time date-time))))

(defun rush-fetch-pulls ()
  (rush-request :path (apply 'format rush-pull-requests-path (rush-get-owner-and-repo))
                :query rush-filters-for-pull-requests
                :success-function (lambda (data)
                                    (rush-print-data (mapcar 'rush-pull->entry data)))))

(provide 'rush-pulls)
