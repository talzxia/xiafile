(when (>= emacs-major-version 24)
    (require 'package)
    (package-initialize)
    (add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t))

;; cl - Common Lisp Extension
(require 'cl)

;; Add Packages
(defvar my/packages '(
	       ;; --- Auto-completion ---
	       company
	       ;; --- Better Editor ---
	       hungry-delete
	       swiper
	       counsel
	       smartparens
	       ;; --- Major Mode ---
	       js2-mode
	       ;; --- Minor Mode ---
	       nodejs-repl
	       exec-path-from-shell
	       ;; --- Themes ---
	       monokai-theme
	       ;; solarized-theme
	       ) "Default packages")

(setq package-selected-packages my/packages)

(defun my/packages-installed-p ()
    (loop for pkg in my/packages
	  when (not (package-installed-p pkg)) do (return nil)
	  finally (return t)))

(unless (my/packages-installed-p)
    (message "%s" "Refreshing package database...")
    (package-refresh-contents)
    (dolist (pkg my/packages)
      (when (not (package-installed-p pkg))
	(package-install pkg))))

;; Find Executable Path on OS X
;(when (memq window-system '(mac ns))
;  (exec-path-from-shell-initialize))
;; 关闭工具栏，tool-bar-mode 即为一个 Minor Mode
(tool-bar-mode -1)

;; 关闭文件滑动控件
(scroll-bar-mode -1)

;; 显示行号
(global-linum-mode 1)

;; 更改光标的样式（不能生效，解决方案见第二集）
(setq cursor-type 'bar)

;; 关闭启动帮助画面
(setq inhibit-splash-screen 1)

;; 关闭缩进 (第二天中被去除)
;; (electric-indent-mode -1)

;; 更改显示字体大小 16pt
;; http://stackoverflow.com/questions/294664/how-to-set-the-font-size-in-emacs
(set-face-attribute 'default nil :height 160)

;; 快速打开配置文件
(defun open-init-file()
  (interactive)
  (find-file "~/.emacs.d/init.el"))

;; 这一行代码，将函数 open-init-file 绑定到 <f2> 键上
(global-set-key (kbd "<f5>") 'open-init-file)


; 开启全局 Company 补全
(global-company-mode 1)

(setq make-backup-files nil)

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-item 10)

(require 'hungry-delete)
(global-hungry-delete-mode)

(require 'smex) ; Not needed if you use package.el
(smex-initialize) ; Can be omitted. This might cause a (minimal) delay
					; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(ivy-mode 1)
(setq ivy-use-virtual-buffers t)
(global-set-key "\C-s" 'swiper)
(global-set-key (kbd "C-c C-r") 'ivy-resume)
(global-set-key (kbd "<f6>") 'ivy-resume)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-load-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c k") 'counsel-ag)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(define-key read-expression-map (kbd "C-r") 'counsel-expression-history)




;; 这个快捷键绑定可以用之后的插件 counsel 代替
;; (global-set-key (kbd "C-x C-r") 'recent-open-files)
(delete-selection-mode 1)

(setq initial-frame-alist (quote ((fullscreen . maximized))))


;(add-hook 'emacs-lisp-mode-hook 'show-paren-mode)
(global-hl-line-mode 1)
;(add-to-list my/packages 'monokai-theme)
(load-theme 'monokai 1)
(require 'helm-config)
(helm-mode 1)

;org语法高亮
(require 'org)
(setq org-src-fontify-natively t)

;; 设置默认 Org Agenda 文件目录
;(setq org-agenda-files '("~/org"))

;; 设置 org-agenda 打开快捷键
(global-set-key (kbd "C-c a") 'org-agenda)

;;下面的代码可以是 Emacs 自动加载外部修改过的文件。
(global-auto-revert-mode 1)

;;使用下面的代码可以关闭自己生产的保存文件（之前我们已经关闭过了 Emacs 自动生产的备份文件了，现在是关闭自动保存文件）。

(setq auto-save-default nil)

(defun indent-buffer()
  (interactive)
  (indent-region (point-min) (point-max)))

(defun indent-region-or-buffer()
  (interactive)
  (save-excursion
    (if (region-active-p)
	(progn
	  (indent-region (region-beginning) (region-end))
	  (message "Indent selected region."))
      (progn
	(indent-buffer)
	(message "Indent buffer.")))))
;;然后再将其用下面的代码将其绑定为快捷键，第一个 \ 用于将紧跟的 \ 进行逃脱（escape）。

;;(global-set-key (kbd "C-M-\\") 'indent-region-or-buffer)
;;使用下面的代码我们可以开启 abbrev 模式并定义一个缩写表，每当我们输入下面的缩写并以空格结束时，Emacs 就会将其自动展开成为我们所需要的字符串。

;(abbrev-mode 1)
;(define-abbrev-table 'global-abbrev-table '(
					    ;; Shifu
;					    ("8zl" "zilongshanren")
					    ;; Tudi
;					    ("8lxy" "lixinyang")
;					   ))

;;我们可以将下面的代码加入到我们的配置文件中，来增强 Hippie Expand 的功能，(setq org-todo-keywords '((type "陈振趣" "李倩" "王树兵" "|" "DONE")))
;;   -*- mode: lisp  -*-
;; .emacs file     Selected entries from ~/.emacs.el
;; file of Charles Cave to run org-mode
(setq org-todo-keywords
    '((sequence "TODO(t!)" "NEXT(n)" "WAITTING(w)" "SOMEDAY(s)" "|" "DONE(d@/!)" "ABORT(a@/!)")
     ))    

(setq org-remember-templates
     '(
      ("Todo" ?t "* TODO %^{Brief Description} %^g\n%?\nAdded: %U" "~/charles/GTD/newgtd.org" "Tasks")
      ("Private" ?p "\n* %^{topic} %T \n%i%?\n" "~/charles/gtd/privnotes.org")
      ("WordofDay" ?w "\n* %^{topic} \n%i%?\n" "~/charles/gtd/wotd.org")
      ))

(define-key global-map [f8] 'remember)
(define-key global-map [f9] 'remember-region)

(setq org-agenda-exporter-settings
      '((ps-number-of-columns 1)
        (ps-landscape-mode t)
        (htmlize-output-type 'css)))

(setq org-agenda-custom-commands
'(

("P" "Projects"   
((tags "PROJECT")))

("H" "Office and Home Lists"
     ((agenda)
          (tags-todo "OFFICE")
          (tags-todo "HOME")
          (tags-todo "COMPUTER")
          (tags-todo "DVD")
          (tags-todo "READING")))

("D" "Daily Action List"
     (
          (agenda "" ((org-agenda-ndays 1)
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 0)
                      ))))
)
)

(defun gtd ()
    (interactive)
    (find-file "~/charles/gtd/newgtd.org")
)
(global-set-key (kbd "C-c g") 'gtd)


(add-hook 'org-agenda-mode-hook 'hl-line-mode)

; org mode start - added 20 Feb 2006
;; The following lines are always needed. Choose your own keys.

(global-font-lock-mode t)

(global-set-key "\C-x\C-r" 'prefix-region)
(global-set-key "\C-x\C-l" 'goto-line)
(global-set-key "\C-x\C-y" 'copy-region-as-kill)

 ;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

(set-variable 'confirm-kill-emacs 'yes-or-no-p)


org-remember-insinuate) (setq org-directory "~/xiafile/xiafile/0.GTD/") (setq org-remember-templates '(("New" ?n "* %? %t \n %i\n %a" "~/xiafile/xiafile/0.GTD/inbox.org" ) ("Task" ?t "** TODO %?\n %i\n %a" "~/xiafile/xiafile/0.GTD/task.org" "Tasks") ("Calendar" ?c "** TODO %?\n %i\n %a" "~/xiafile/xiafile/0.GTD/task.org" "Tasks") ("Idea" ?i "** %?\n %i\n %a" "~/xiafile/xiafile/0.GTD/task.org" "Ideas") ("Note" ?r "* %?\n %i\n %a" "~/xiafile/xiafile/0.GTD/note.org" ) ("Project" ?p "** %?\n %i\n %a" "~/xiafile/xiafile/0.GTD/project.org" %g) )) (setq org-default-notes-file (concat org-directory "/inbox.org"))


