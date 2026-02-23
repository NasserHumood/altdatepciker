# frozen_string_literal: true

module Sama
  class DatePickerComponent < ApplicationComponent
    # ~
    # تعيين القيم الإفتراضية
    # ~
    def initialize(date: Date.current, selected: nil)
      @date = date
      @selected = selected

      # ~ معالجة مرة واحدة فقط
      @first_of_chosen_month = @date.beginning_of_month
      @previous_month_date = @first_of_chosen_month - 1.month
      @next_month_date = @first_of_chosen_month + 1.month
    end

    private

    # ~
    # دالة: إنشاء مصفوفة الشهر
    # ~
    def month_array
      # ~ معلومات عامة عن الشهر
      leading_blanks = @first_of_chosen_month.wday
      total_days = Time.days_in_month(@date.month, @date.year)

      # ~ معلومات عن الشهر الفائت
      previous_total_days = Time.days_in_month(@previous_month_date.month, @previous_month_date.year)

      # ~ تعيين مصفوفة الأيام السابقة
      previous_days = []

      # ~ حساب الأيام الفارغة في البداية
      if leading_blanks > 0
        first_day = previous_total_days - leading_blanks + 1
        (first_day..previous_total_days).each do |d|
          previous_days << {
            day: d,
            type: :previous,
            datetime: "#{@previous_month_date.year}-#{@previous_month_date.month}-#{d}"
          }
        end
      end

      # ~ أيام الشهر الحالي
      current_days = (1..total_days).map { |d|
        {
          day: d,
          type: :current,
          datetime: "#{@date.year}-#{@date.month}-#{d}"
        }
      }

      # ~ تغيير نوع اليوم الحالي.
      if (@date.month == Date.current.month) && (@date.year == Date.current.year)
        today_index = Date.current.day
        current_days[today_index - 1] = {
          day: today_index,
          type: :now,
          datetime: Date.current.to_s
        }
      end

      # ~ تعيين المصفوفة الأساسية
      main_array = previous_days + current_days

      # ~ إضافة بقية الخلايا لإكمال 42 خلية باستخدام الشهر القادم
      if main_array.length < 42
        difference = 42 - main_array.length
        next_days = (1..difference).map { |d|
          {
            day: d,
            type: :next,
            datetime: "#{@next_month_date.year}-#{@next_month_date.month}-#{d}"
          }
        }
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
      datetime = cell[:datetime]

      case type
      when :previous, :next
        button_to url_for(calendar_update_path),
          method: :post,
          params: {date: datetime.to_date, selected: datetime},
          form_class: "bg-gray-50 py-1.5 text-gray-400 hover:bg-gray-100 focus:z-10" do
          tag.time(day, datetime: datetime, class: "mx-auto flex size-5 items-center justify-center rounded-full")
        end

      when :now
        button_to url_for(calendar_update_path),
          method: :post,
          params: {date: datetime.to_date, selected: datetime},
          form_class: "bg-white py-1.5 font-semibold text-indigo-600 hover:bg-gray-100 focus:z-10" do
          tag.time(day, datetime: datetime, class: "mx-auto flex size-5 items-center justify-center rounded-full")
        end

      else
        button_to url_for(calendar_update_path),
          method: :post,
          params: {date: datetime.to_date, selected: datetime},
          form_class: "bg-white py-1.5 text-gray-900 hover:bg-gray-100 focus:z-10" do
          tag.time(day, datetime: datetime, class: "mx-auto flex size-5 items-center justify-center rounded-full")
        end

      end
    end
  end
end
