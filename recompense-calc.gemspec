# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "RecompenseCalc"
  spec.version       = '1.0'
  spec.authors       = ["Andrew Anderson"]
  spec.email         = ["andrew@substratalcode.com"]
  spec.summary       = %q{A calculator for project reimbursement.}
  spec.description   = %q{For a set of projects for a client, this calculates the amount of reimbursement required.}
  spec.homepage      = "https://substratalcode.com/"
  spec.license       = "MIT"

  spec.files         = ['lib/recompense_calc.rb']
  spec.executables   = ['bin/recompense_calc']
  spec.test_files    = ['tests/test_recompense_calc.rb']
  spec.require_paths = ["lib"]
end
