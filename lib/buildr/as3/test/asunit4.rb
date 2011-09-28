#
# Copyright (C) 2011 by Weyert de Boer
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#

require 'buildr'
require 'fileutils'
require "rexml/document"

module Buildr
  module AS3
    module Test
      # AsUnit4 test framework.
      #
      # Support the following options:
      # * :player            -- ["air","flash"] defines the player to run the tests, when not set it chooses based on the projects compiler.
      # * :allow_testsuite   -- [Boolean] allow the regeneration of the testsuite class AllTests.as with the buildr unit tests settings
      # * :localTrusted      -- [Boolean] create the flash player local snadbox policy file
      class AsUnit4 < TestFramework::AS3
        
        def initialize(project, options) #:nodoc:
          super
          options[:debug] = Buildr.options.debug if options[:debug].nil?
          options[:warnings] ||= true
        end

        class << self
          def generate_testsuite(candidates) #:nodoc:
            puts "generate_testsuite"
            puts candidates
          end          
        end

        def tests(dependencies) #:nodoc:
          candidates = []
          task.project.test.compile.sources.each do |source|
            files = Dir["#{source}/**/*Test.as"] + Dir["#{source}/**/*Test.mxml"]
            files.each { |item|
              if File.dirname(item) == source
                candidates << File.basename(item, '.*')
              else
                candidates << "#{File.dirname(item).gsub!(source+"/", "").gsub!("/", ".")}.#{File.basename(item, '.*')}"
              end
            }
          end
          
          candidates
        end

        def run(tests, dependencies) #:nodoc:
          generate_testsuite(tests)
          
          tests
        end
      end
    end
  end
end