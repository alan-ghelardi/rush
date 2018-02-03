(require 'rush-git)
(require 'rush-github-client)

(defconst rush-pull-requests-path "/repos/%s/%s/pulls")

(defun rush-pull->entry (pull)
  (list (assq 'title pull)
        (assq 'number pull)
        (assq 'state pull)
        (assq 'created_at pull)))

(defun rush-fetch-pulls ()
  (rush-request :path (apply 'format rush-pull-requests-path (rush-get-owner-and-repo))
                :query '(("state" . "open"
                          ))
                :success-function (lambda (data)
                                    (rush-print-data (mapcar 'rush-pull->entry data)))))

(provide 'rush-pulls)
