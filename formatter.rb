require 'rspec/core'
require 'rspec/core/formatters/base_text_formatter'

class PikaFormater < ::RSpec::Core::Formatters::BaseTextFormatter

  ::RSpec::Core::Formatters.register self,
                                     :stop,
                                     :dump_failures,
                                     :example_failed,
                                     :example_passed,
                                     :example_pending,
                                     :start

  def initialize(*args)
    super

    @pika = load_pika
    @current_frame = 0
  end

  def delete(lines_back = 1)
    erase_lines = "\r" + "\e[A" * lines_back + "\e[J"
    print erase_lines
  end

  def load_pika
    pika = File.read(File.join(File.dirname(__FILE__), 'pika.txt'))
    pika.split("SPLIT")[1..20].map { _1.lines[20..].join }
  end

  def start(_notification)
    puts @pika.first
  end

  def print_next
    delete 24
    puts @pika[@current_frame]
    @current_frame = (@current_frame + 1) % @pika.size
  end

  def example_passed(_notification)
    print_next
  end

  def example_failed(_notification)
    print_next
  end

  def example_pending(_notification)
    print_next
  end

  def stop(_notification)
    delete 24
  end
end


