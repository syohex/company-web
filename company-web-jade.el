;;; company-web-jade.el --- company for jade-mode

;; Copyright (C) 2015 Olexandr Sydorchuck

;; Author: Olexandr Sydorchuck <olexandr.syd@gmail.com>
;; Keywords: jade, company, auto-complete, javascript

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; Configuration:
;;

;;; Code:

(require 'company-web)

(defconst company-web/jade-get-tag-re
  (concat "^[\t ]*\\(" company-web-selector "+\\)(")
  "Regexp of jade attribute or tag")

(defconst company-web/jade-get-attribute-re
  (concat "[^[:alnum:]-]\\(" company-web-selector "+\\) *=")
  "Regexp of jade attribute or tag")

(defun company-web/current-jade-tag ()
  "Return current jade tag user is typing on."
  (save-excursion
    (re-search-backward company-web/jade-get-tag-re nil t)
    (match-string 1)))

(defun company-web/current-jade-attribute ()
  "Return current jade tag's attribute user is typing on."
  (save-excursion
    (re-search-backward company-web/jade-get-attribute-re nil t)
    (match-string 1)))

(defconst company-web/jade-div-id-regexp
  (concat "^ *#\\(" company-web-selector "*\\)")
  "A regular expression matching Jade #idofdiv:

  #bar -> <div id=\"bar\">
.")

(defconst company-web/jade-div-class-regexp
  (concat "^ *\\(?:#"  "[a-z]+\\|\\)"
          "[.]\\(" company-web-selector "*\\)")
  "A regular expression matching Jade div's class:

  .foo -> <div class=\"foo\">
or
  #foo.baz -> <div id=\"foo\" class=\"baz\">
.")

(defconst company-web/jade-tag-regexp
  (concat "^[\t ]*\\(" company-web-selector "*\\)")
  "A regular expression matching Jade tags.")

(defconst company-web/jade-attribute-regexp
  (concat "\\(?:,\\|(\\)[ ]*\\(.*\\)")
  "A regular expression matching Jade attribute.")

(defconst company-web/jade-value-regexp
  (concat "\\w *= *[\"]\\(?:[^\"]+[ ]\\|\\)\\(" company-web-selector "*\\)")
  "A regular expression matching Jade attribute.")

;;;###autoload
(defun company-web-jade (command &optional arg &rest ignored)
  "`company-mode' completion back-end for `jade-mode'."
  (interactive (list 'interactive))
  (cl-case command
    (interactive (company-begin-backend 'company-web-jade))
    (ignore-case t)
    (duplicates nil)
    (prefix (and (derived-mode-p 'jade-mode)
                 (or (company-grab company-web/jade-value-regexp 1)
                     (company-grab company-web/jade-tag-regexp 1)
                     (company-grab company-web/jade-div-id-regexp 1)
                     (company-grab company-web/jade-div-class-regexp 1)
                     (company-grab company-web/jade-attribute-regexp 1)
                     )))
    (candidates
     (cond
      ;; value
      ((company-grab company-web/jade-value-regexp 1)
       (all-completions arg (company-web-candidates-attrib-values (company-web/current-jade-tag)
                                                           (company-web/current-jade-attribute))))
      ;; class ".foo" or id "#bar"
      ((and (not (company-web-is-point-in-string-face))
            (company-grab company-web/jade-div-id-regexp 1))
       (all-completions arg
                        (company-web-candidates-attrib-values "div" "id")))
      ((and (not (company-web-is-point-in-string-face))
            (company-grab company-web/jade-div-class-regexp 1))
       (all-completions arg
                        (company-web-candidates-attrib-values "div" "class")))
      ;; tag
      ((and (not (company-web-is-point-in-string-face))
            (company-grab company-web/jade-tag-regexp 1))
       (all-completions arg (company-web-candidates-tags)))
      ;; attr
      ((and (not (company-web-is-point-in-string-face))
            (company-grab company-web/jade-attribute-regexp 1))
       (all-completions arg (company-web-candidates-attribute (company-web/current-jade-tag))))))
    (annotation (company-web-annotation arg))
    (doc-buffer
     ;; No need grab for attribute value, attribute regexp will match enyway
     (cond
      ;; tag
      ((company-grab company-web/jade-tag-regexp 1)
       (company-web-tag-doc arg))
      ;; attr
      ((company-grab company-web/jade-attribute-regexp 1)
       (company-web-attribute-doc (company-web/current-jade-tag) arg))))))

;;; company-web-jade.el ends here