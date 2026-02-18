# frozen_string_literal: true

module Sama
  class DatePickerComponent < ApplicationComponent
    # ~
    # تعيين القيم الإفتراضية
    # ~
    def initialize(month: Date.current.month, year: Date.current.year)
      @month = month
      @year = year
    end

    private

    # ~
    # دالة: إنشاء مصفوفة الشهر
    # ~
    def month_array
      # ~ معلومات عامة عن الشهر
      first_of_month = Date.new(@year, @month, 1)
      leading_blanks = first_of_month.wday
      total_days = Time.days_in_month(@month, @year)

      # ~ معلومات عن الشهر الفائت
      previous_total = Time.days_in_month(previous_month, previous_year)

      # ~ تعيين مصفوفة الأيام السابقة
      previous_days = []

      # ~ حساب الأيام الفارغة في البداية
      if leading_blanks > 0
        first_day = previous_total - leading_blanks + 1
        (first_day..previous_total).each do |d|
          previous_days << {day: d, type: :previous}
        end
      end

      # ~ أيام الشهر الحالي
      current_days = (1..total_days).map { |d| {day: d, type: :current} }

      # ~ تغيير نوع اليوم الحالي.
      if (@month == Date.current.month) && (@year == Date.current.year)
        today_index = Date.current.day
        current_days[today_index - 1] = {day: today_index, type: :now}
      end

      # ~ تعيين المصفوفة الأساسية
      main_array = previous_days + current_days

      # ~ إضافة أيام الشهر التالي (trailing) لنكمل 42 خلية
      if main_array.length < 42
        difference = 42 - main_array.length
        next_days = (1..difference).map { |d| {day: d, type: :next} }
        main_array += next_days
      end

      main_array
    end

    # ~
    # دالة: إنشاء الزر
    # ~
    def one_cell(cell)
      day = cell[:day]
      type = cell[:type]

      case type
      when :previous, :next
        tag.button(class: "bg-gray-50 py-1.5 text-gray-400 hover:bg-gray-100 focus:z-10") do
          # <time datetime="2022-01-02" class="mx-auto flex size-7 items-center justify-center rounded-full">3</time>
          tag.time(day.to_s, class: "mx-auto flex size-5 items-center justify-center rounded-full")
        end
      when :now
        tag.button(class: "bg-white py-1.5 font-semibold text-indigo-600 hover:bg-gray-100 focus:z-10") do
          # <time datetime="2022-01-02" class="mx-auto flex size-7 items-center justify-center rounded-full">3</time>
          tag.time(day.to_s, class: "mx-auto flex size-5 items-center justify-center rounded-full")
        end
      else
        tag.button(class: "bg-white py-1.5 text-gray-900 hover:bg-gray-100 focus:z-10") do
          # <time datetime="2022-01-02" class="mx-auto flex size-7 items-center justify-center rounded-full">3</time>
          tag.time(day.to_s, class: "mx-auto flex size-5 items-center justify-center rounded-full")
        end
      end
    end

    # ~
    # الشهر الماضي
    # ~
    def previous_month
      (@month == 1) ? 12 : @month - 1
    end

    # ~
    # السنة الماضية
    # ~
    def previous_year
      (@month == 1) ? @year - 1 : @year
    end

    # ~
    # الشهر القادم
    # ~
    def next_month
      (@month == 12) ? 1 : @month + 1
    end

    # ~
    # السنة القائدمة
    # ~
    def next_year
      (@month == 12) ? @year + 1 : @year
    end
  end
end
