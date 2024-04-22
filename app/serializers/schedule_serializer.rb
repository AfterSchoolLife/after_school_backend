class ScheduleSerializer < ActiveModel::Serializer
  attributes :id, :days, :start_time, :end_time, :start_date, :end_date, :age_group, :price, :is_active, :school_id, :program_id


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
    object.program.image_url
  end
  

  attribute :school_name
  attribute :school_address
  attribute :program_name
  attribute :program_description
  attribute :program_image_url
end
