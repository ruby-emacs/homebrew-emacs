require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class GroovyMode < EmacsFormula
  desc "Modes for Groovy and Groovy-related technology"
  homepage "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes"
  head "https://github.com/Groovy-Emacs-Modes/groovy-emacs-modes.git"

  depends_on :emacs => "22.1"

  def install
    el_array = %w[groovy-mode.el groovy-electric.el inf-groovy.el]
    byte_compile el_array
    elisp.install el_array, Dir["*.elc"]

    doc.install "gplv2.txt"
  end

  def caveats; <<-EOS.undent
    Grails mode was not installed, as it currently has additional dependencies
    not available in Homebrew.
  EOS
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "groovy-mode")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end