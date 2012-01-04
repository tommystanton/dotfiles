(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-number-mode t)
 '(fill-column 72)
 '(menu-bar-mode t)
 '(save-place t nil (saveplace))
 '(size-indication-mode t)
 '(text-mode-hook (quote (turn-on-auto-fill text-mode-hook-identify)))
 '(transient-mark-mode t))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )
;; Remove splash screen
(setq inhibit-splash-screen t)
;; Don't make backup files
(setq make-backup-files nil)
; no "#" files after a save
(setq delete-auto-save-files t)

;; From Jonathan Rockway
;; https://github.com/jrockway/dotfiles/blob/master/emacs
(defun xml-unescape ()
  (interactive)
  (ignore-errors (replace-string "\\x0a" "\n" nil (point-min) (point-max)))
  (ignore-errors (replace-string "\\\"" "\"" nil (point-min) (point-max)))
  (ignore-errors (replace-string "&#xa;" "\n" nil (point-min) (point-max)))
  (ignore-errors (replace-string "&lt;" "<" nil (point-min) (point-max)))
  (ignore-errors (replace-string "&gt;" ">" nil (point-min) (point-max)))
  (ignore-errors (replace-string "&quot;" "\"" nil (point-min) (point-max)))
  (ignore-errors (replace-string "&apos;" "'" nil (point-min) (point-max)))
  (ignore-errors (replace-string "&amp;" "&" nil (point-min) (point-max))))
