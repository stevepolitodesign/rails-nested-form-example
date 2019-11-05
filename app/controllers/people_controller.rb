class PeopleController < ApplicationController

    before_action :set_person, only: [:show, :edit, :update, :destroy]

    def index
        @people = Person.all
    end

    def new
        @person = Person.new
    end

    def create
        @person = Person.create(person_params)
        if @person.save
            redirect_to @person, notice: "#{@person.first_name} #{@person.last_name} was successfully created."
        else
            render "new"
        end
    end

    def show
    end

    def edit
    end

    def update
        if @person.update(person_params)
            redirect_to @person, notice: "#{@person.first_name} #{@person.last_name} was successfully updated."
        else
            render "edit"
        end
    end

    def destroy
        @person.destroy
        redirect_to people_path, notice: "#{@person.first_name} #{@person.last_name} was successfully deleted."
    end

    private 

        def set_person
            @person = Person.find(params[:id])
        end

        def person_params
            params.require(:person).permit(:first_name, :last_name)
        end
end