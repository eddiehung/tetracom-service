FactoryGirl.define do
	factory :user do
		#name		"Michael Hartl"
		#email		"michael@example.com"
		sequence(:name)  { |n| "Person #{n}" }
		sequence(:email) { |n| "person_#{n}@example.com" }
		phone		"+44(0)1234567890"
		sequence(:affiliation)	{ |n| "Top #{n} university" }
		expertise	"FPGA, ASIC"
		password	"foobar"
		password_confirmation	"foobar"
		show_name 	true
		show_email  true
		show_phone  true
		show_affiliation	true

		factory :admin do
			admin true
		end
	end
end
