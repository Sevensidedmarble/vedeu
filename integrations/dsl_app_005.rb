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
                  filename:   '/tmp/dsl_app_005.out',
                  write_file: true),
                # Vedeu::Renderers::JSON.new(filename: '/tmp/dsl_app_005.json'),
                # Vedeu::Renderers::HTML.new(filename: '/tmp/dsl_app_005.html'),
                # Vedeu::Renderers::Text.new(filename: '/tmp/dsl_app_005.txt'),
              ]
    run_once!
    standalone!
  end

  load './support/test_interface.rb'

  Vedeu.render do
    view(:test_interface) do
      lines do
        background '#000066'
        line 'view->lines->line 1', { foreground: '#00ff00' }
        line 'view->lines->line 2', { background: '#000000', foreground: '#007fff' }
        line 'view->lines->line 3', { foreground: '#55aa00' }
      end
    end
  end

  def self.actual
    File.read('/tmp/dsl_app_005.out')
  end

  def self.expected
    File.read(File.expand_path('../expected/dsl_app_005.out', __FILE__))
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
