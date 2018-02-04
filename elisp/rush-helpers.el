(defconst rush-date-time-formatter "%a %b %d %T %Y")

(defun rush-format-date-time (date-time)
  (format-time-string rush-date-time-formatter (date-to-time date-time)))

(provide 'rush-helpers)
