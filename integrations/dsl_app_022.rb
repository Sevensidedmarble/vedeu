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
                  filename:   '/tmp/dsl_app_022.out',
                  write_file: true),
                # Vedeu::Renderers::JSON.new(filename: '/tmp/dsl_app_022.json'),
                # Vedeu::Renderers::HTML.new(filename: '/tmp/dsl_app_022.html'),
                # Vedeu::Renderers::Text.new(filename: '/tmp/dsl_app_022.txt'),
              ]
    run_once!
    standalone!
    height 50
    width 100
  end

  load './support/test_interface_022.rb'

  Vedeu.render do
    view(:test_interface) do
      line do
        stream '2--'
        stream '+', foreground: '#ffff00'
        stream '----10--------20--------30--------40--------50'
        stream '--------60--------70--------80---'
        stream '+', foreground: '#ffff00'
        stream '----90---'
        stream '+', foreground: '#ffff00'
        stream '----100'
        stream '-------10--------20--------30--------40-------50'
      end
      line do
        stream '- '
        stream 'geometry height: 40', foreground: '#aadd00'
      end
      line do
        stream '- '
        stream 'geometry width: 90', foreground: '#aadd00'
      end
      line '+', foreground: '#ffff00'
      line '-'
      line '-'
      line '-'
      line '-'
      line '10'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '20'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '30'
      line '-'
      line '-'
      line '-'
      line '-'
      line '+', foreground: '#ffff00'
      line '-'
      line '-'
      line '-'
      line '-'
      line '40'
      line '-'
      line '-'
      line '-'
      line '-'
      line '+', foreground: '#ffff00'
      line '-'
      line '-'
      line '-'
      line '-'
      line '50'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '-'
      line '60'
    end
  end

  def self.actual
    File.read('/tmp/dsl_app_022.out')
  end

  def self.expected
    File.read(File.expand_path('../expected/dsl_app_022.out', __FILE__))
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
