require 'spec_helper'

describe User do
	before {@user = User.new(name: "Example User", email: "user@example.com",
							 password: "foobar", password_confirmation: "foobar")}
	subject{ @user }
	it {should respond_to(:name)}
	it {should respond_to(:email)}
	it {should respond_to(:password_digest)}
	it {should respond_to(:password)}
	it {should respond_to(:password_confirmation)}
	it {should be_valid}

	describe "wahen name is not present" do
		before{@user.name = " "}
		it {should_not be_valid}
	end

	describe "when email is not presence" do
		before{@user.email= " "}
		it {should_not be_valid}
	end

	describe "when name to long" do
		before {@user.name = "a" * 51}
		it {should_not be_valid}
	end

	describe "when email format is invalid" do
		it "should be valid " do
			emails = %w[user@foo,com example.user@foo. user_at_foo.org]
			emails.each do |invalid_email|
				@user.email = invalid_email
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "shoud be valid" do
			emails = %w[user@foo.com USER_US@b.a.r.org first.name@email.jp a+b@baz.cn]
			emails.each do |valid_email|
				@user.email = valid_email
				@user.should be_valid
			end
		end
	end

	describe "when email is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end
		it {should_not be_valid}
	end

	describe "when password in't presence" do
		before {@user.password = @user.password_confirmation = " "}
		it {should_not be_valid}
	end

	describe "when password doesn't match confirmation" do
		before {@user.password_confirmation = "mismatch"}
		it {should_not be_valid}
	end


	describe "when password confirmation is nil" do
		before {@user.password_confirmation = nil}
		it {should_not be_valid}
	end

	describe "when password is too short" do
		before{@user.password_confirmation = "a" * 5}
		it{should_not be_valid}
	end

	describe "return value of authentication method" do
		before {@user.save}
		let(:found_user) {User.find_by_email(@user.email)}

		describe "with valid pasword" do
			it {should == found_user.authenticate(@user.password)}
		end
		describe "with invalid password" do
			let(:user_with_invalid_password) {found_user.authenticate("invalid")}
			it {should_not == user_with_invalid_password}
			specify {user_with_invalid_password.should be_false}
		end
	end
end
