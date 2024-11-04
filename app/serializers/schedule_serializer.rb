class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :no_class_dates, :days, :start_time, :end_time, :start_date, :end_date, :age_group, :price, :is_active, :school_id, :program_id, :teacher_name, :cost_of_teacher, :facility_rental, :total_available, :currently_available


  def school_name
    object.school.name
  end
  def school_address
    object.school.address
  end

  def program_name
    object.program.title
  end
  def program_description
    object.program.description
  end
  def program_image_url
    if object.program.image.attached?
      Rails.application.routes.url_helpers.url_for(object.program.image)
    else
      object.program.image_url
    end
  end
  

  attribute :school_name
  attribute :school_address
  attribute :program_name
  attribute :program_description
  attribute :program_image_url
end
