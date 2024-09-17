class TeachersController < ApplicationController
    before_action :authenticate_user!
  before_action :set_teacher, only: [:show, :update, :destroy]
  before_action :authorize_teacher, only: [:update, :destroy]

  
  def index
    @teachers = Teacher.all
    render json: @teachers
  end

  
  def show
    render json: @teacher
  end

  
  def create
    @teacher = Teacher.new(teacher_params)
    @teacher.user = current_user 

    if @teacher.save
      render json: @teacher, status: :created
    else
      render json: @teacher.errors, status: :unprocessable_entity
    end
  end

 
  def update
    if @teacher.update(teacher_params)
      render json: @teacher
    else
      render json: @teacher.errors, status: :unprocessable_entity
    end
end
