require File.expand_path("../../Homebrew/emacs_formula", __FILE__)

class Yasnippet < EmacsFormula
  desc "Emacs template system"
  homepage "https://github.com/joaotavora/yasnippet"
  url "https://elpa.gnu.org/packages/yasnippet-0.10.0.tar"
  sha256 "bb75c4ead91547cc4d178ad522a9f0f23eadd553d9924cdfefcace3c4e04076e"
  head "https://github.com/joaotavora/yasnippet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "2763ff9ef3add0b80a4afa32cac9d3e2ba79ab295c83f2a14577d61a810d1d7f" => :sierra
    sha256 "2763ff9ef3add0b80a4afa32cac9d3e2ba79ab295c83f2a14577d61a810d1d7f" => :el_capitan
    sha256 "2763ff9ef3add0b80a4afa32cac9d3e2ba79ab295c83f2a14577d61a810d1d7f" => :yosemite
  end

  option "with-htmlize", "Build HTML docs with htmlize"

  depends_on :emacs => "23.1"
  depends_on "homebrew/emacs/htmlize" => :optional
  depends_on "homebrew/emacs/cl-lib" if Emacs.version < Version.create("24.3")

  def install
    ert_run_tests "yasnippet-tests.el"
    byte_compile "yasnippet.el"

    if build.with? "htmlize"
      system "rake", "doc[#{Formula["htmlize"].opt_elisp}]"
      doc.install "doc/images", "doc/stylesheets", Dir["doc/*.html"]
    end

    elisp.install Dir["*.el"], Dir["*.elc"]
    (prefix/"contrib").install "snippets"
  end

  def caveats
    "Snippets have been installed to #{opt_prefix}/contrib"
  end

  test do
    (testpath/"test.el").write <<-EOS.undent
      (add-to-list 'load-path "#{elisp}")
      (load "yasnippet")
      (print (minibuffer-prompt-width))
    EOS
    assert_equal "0", shell_output("emacs -Q --batch -l #{testpath}/test.el").strip
  end
end
