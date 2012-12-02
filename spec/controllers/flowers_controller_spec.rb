require 'spec_helper'

describe FlowersController do
  # This should return the minimal set of attributes required to create a valid
  # flower. As you add validations to flower, be sure to
  # update the return value of this method accordingly.
  def valid_attributes
    { :name => "simple name", :cosmId => "test" }
  end

  # This should return the minimal set of values that should be in the session
  # in order to pass any filters (e.g. authentication) defined in
  # flowersController. Be sure to keep this updated too.
  def valid_session
    {}
  end

  describe "GET index" do
    it "assigns all flowers as @flowers" do
      flower = Flower.create! valid_attributes
      get :index, {}, valid_session
      assigns(:flowers).should eq([flower])
    end
  end

  describe "GET show" do
    it "assigns the requested flower as @flower" do
      flower = Flower.create! valid_attributes
      get :show, {:id => flower.to_param}, valid_session
      assigns(:flower).should eq(flower)
    end
  end

  describe "GET new" do
    it "assigns a new flower as @flower" do
      get :new, {}, valid_session
      assigns(:flower).should be_a_new(Flower)
    end
  end

  describe "GET edit" do
    it "assigns the requested flower as @flower" do
      flower = Flower.create! valid_attributes
      get :edit, {:id => flower.to_param}, valid_session
      assigns(:flower).should eq(flower)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new flower" do
        expect {
          post :create, {:flower => valid_attributes}, valid_session
        }.to change(Flower, :count).by(1)
      end

      it "assigns a newly created flower as @flower" do
        post :create, {:flower => valid_attributes}, valid_session
        assigns(:flower).should be_a(Flower)
        assigns(:flower).should be_persisted
      end

      it "redirects to the created flower" do
        post :create, {:flower => valid_attributes}, valid_session
        response.should redirect_to(Flower.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved flower as @flower" do
        # Trigger the behavior that occurs when invalid params are submitted
        Flower.any_instance.stub(:save).and_return(false)
        post :create, {:flower => {  }}, valid_session
        assigns(:flower).should be_a_new(Flower)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Flower.any_instance.stub(:save).and_return(false)
        post :create, {:flower => {  }}, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested flower" do
        flower = Flower.create! valid_attributes
        # Assuming there are no other flowers in the database, this
        # specifies that the flower created on the previous line
        # receives the :update_attributes message with whatever params are
        # submitted in the request.
        Flower.any_instance.should_receive(:update_attributes).with({ "these" => "params" })
        put :update, {:id => flower.to_param, :flower => { "these" => "params" }}, valid_session
      end

      it "assigns the requested flower as @flower" do
        flower = Flower.create! valid_attributes
        put :update, {:id => flower.to_param, :flower => valid_attributes}, valid_session
        assigns(:flower).should eq(flower)
      end

      it "redirects to the flower" do
        flower = Flower.create! valid_attributes
        put :update, {:id => flower.to_param, :flower => valid_attributes}, valid_session
        response.should redirect_to(flower)
      end
    end

    describe "with invalid params" do
      it "assigns the flower as @flower" do
        flower = Flower.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Flower.any_instance.stub(:save).and_return(false)
        put :update, {:id => flower.to_param, :flower => {  }}, valid_session
        assigns(:flower).should eq(flower)
      end

      it "re-renders the 'edit' template" do
        flower = Flower.create! valid_attributes
        # Trigger the behavior that occurs when invalid params are submitted
        Flower.any_instance.stub(:save).and_return(false)
        put :update, {:id => flower.to_param, :flower => {  }}, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested flower" do
      flower = Flower.create! valid_attributes
      expect {
        delete :destroy, {:id => flower.to_param}, valid_session
      }.to change(Flower, :count).by(-1)
    end

    it "redirects to the flowers list" do
      flower = Flower.create! valid_attributes
      delete :destroy, {:id => flower.to_param}, valid_session
      response.should redirect_to(flowers_url)
    end
  end
end
