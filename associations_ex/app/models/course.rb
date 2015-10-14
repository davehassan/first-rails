class Course < ActiveRecord::Base

  has_many :enrollments,
    class_name: "Enrollment",
    foreign_key: :course_id,
    primary_key: :id

  belongs_to :professor,
    class_name: "User",
    foreign_key: :instructor_id,
    primary_key: :id
end
