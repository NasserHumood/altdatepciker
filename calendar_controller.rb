# ~
# متحكّم: التقويم
# ~
# هذا المتحكّم هو المسؤول على إدارة إضافة التقويم.
# ~
class Misc::CalendarController < ApplicationController
  # ~
  # أمر: تحديث الفريم
  # ~
  def update
    respond_to do |format|
      format.turbo_stream do
        render turbo_stream:
          turbo_stream.update(
            "date_picker",
            Sama::DatePickerComponent.new(
              date: params[:date].to_date,
              selected: params[:selected].to_i
            )
          )
      end
    end
  end
end
