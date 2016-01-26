class PackageUpdater
  class PersonExtractor
    def initialize(person_data_string)
      @person_data_string = person_data_string.to_s
    end

    def people
      person_data_string.
        split(',').map(&:strip).
        map do |person_string|
          name, email = person_string.split(' <')
          name.strip!
          email = email.to_s.gsub('>','').strip
          person = Person.find_or_create_by!(name: name)
          person.update_attributes!(email: email) if email.present?
          person
        end
    end

    private

    attr_reader :person_data_string
  end
end
