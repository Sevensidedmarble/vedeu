#!/usr/bin/env ruby

# frozen_string_literal: true

require 'bundler/setup'
require 'vedeu'

class DSLApp

  Vedeu.bind(:_initialize_) { Vedeu.trigger(:_refresh_) }

  Vedeu.configure do
    debug!
    log '/tmp/vedeu_views_dsl.log'
    renderers [
                Vedeu::Renderers::Terminal.new(
                  filename:   '/tmp/dsl_app_014.out',
                  write_file: true),
                # Vedeu::Renderers::JSON.new(filename: '/tmp/dsl_app_014.json'),
                # Vedeu::Renderers::HTML.new(filename: '/tmp/dsl_app_014.html'),
                # Vedeu::Renderers::Text.new(filename: '/tmp/dsl_app_014.txt'),
              ]
    run_once!
    standalone!
  end

  load './support/test_interface.rb'

  Vedeu.render do
    view(:test_interface) do
      lines do
        right 'view->lines->right 1', { foreground: '#00ff00' }
        right 'view->lines->right 2', { background: '#00ff00', foreground: '#000000' }
      end
    end
  end

  def self.actual
    File.read('/tmp/dsl_app_014.out')
  end

  def self.expected
    File.read(File.expand_path('../expected/dsl_app_014.out', __FILE__))
  end

  def self.start(argv = ARGV)
    Vedeu::Launcher.execute!(argv)
  end

end # DSLApp

DSLApp.start

if DSLApp.expected == DSLApp.actual
  puts "#{__FILE__} \e[32mPassed.\e[39m"
  exit 0;
else
  puts "#{__FILE__} \e[31mFailed.\e[39m"
  exit 1;
end
