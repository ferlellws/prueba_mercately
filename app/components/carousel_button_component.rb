# frozen_string_literal: true

class CarouselButtonComponent < ViewComponent::Base
  def initialize(direction:)
    super

    @direction = direction
  end

  attr_reader :direction

  attr_reader :direction

  def button_classes
    "absolute top-0 #{direction == :prev ? 'start-0' : 'end-0'} z-30 flex items-center justify-center h-full px-4 cursor-pointer group focus:outline-none"
  end

  def span_classes
    "inline-flex items-center justify-center w-10 h-10 rounded-full bg-gray-200/30 dark:bg-gray-800/30 group-hover:bg-gray-200/50 dark:group-hover:bg-gray-800/60 group-focus:ring-4 group-focus:ring-gray-200 dark:group-focus:ring-gray-800/70 group-focus:outline-none"
  end

  def data_attributes
    { "carousel-#{direction}": true }
  end

  def icon_svg
    %(<svg class="w-4 h-4 text-gray-200 dark:text-gray-800 #{'rtl:rotate-180' if direction == :prev}" aria-hidden="true" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 6 10"><path stroke="currentColor" stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M#{direction == :prev ? '5 1 1 5l4 4' : '1 9l4-4-4-4'}"/></svg>).html_safe
  end
end
