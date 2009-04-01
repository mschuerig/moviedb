
module MovieDb
  class Populator
    def initialize(people_count, movies_count)
      @people_count, @movies_count = people_count, movies_count
      @max_actors_per_movie = [(@people_count * 20)/@movies_count, 30, @people_count].min
    end
    
    def populate
      create_people(@people_count)
      create_movies(@movies_count)
      add_participants_to_movies(@max_actors_per_movie)
      give_awards
    end
    
    private
    
    module ArraySample
      def sample(n = 1)
        n = [size, n].min
        values_at(*n_distinct_rands(size, n))
      end
      private
      def n_distinct_rands(max, n)
        rands = Set.new
        rands.add(Kernel.rand(max)) until rands.size == n
        rands.to_a
      end
    end
    
    def extend_with_sample(ary)
      unless ary.respond_to?(:sample)
        ary.extend(ArraySample)
      end
      ary
    end
    
    def random_people(n)
      if @people_count > 10000
        Person.find(:all, :order => 'random()', :limit => n)
      else
        @people ||= extend_with_sample(Person.find(:all))
        @people.sample(n)
      end
    end
    
    def random_person
      random_people(1)[0]
    end

    def random_movies(year, n)
      if @movies_count > 10000
        Movie.find(:all, 
          :conditions => { :release_year => year },
          :order => 'random()', :limit => n)
      else
        unless @movies_by_year
          @movies_by_year = Movie.find(:all).index_by(&:release_year)
          @movies_by_year.each_value { |v| extend_with_sample(v) }
        end
        (@movies_by_year[year] || []).sample(n)
      end
    end

    def movie_years
      Movie.connection.select_values('select distinct release_year from movies')
    end

    def create_people(count)
      puts "Creating people..."
      count.times do
        Person.make
      end
    end
    
    def create_movies(count)
      puts "Creating movies..."
      count.times do
        Movie.make
      end
    end
    
    def add_participants_to_movies(max_actors_count)
      puts "Adding people to movies..."
      Movie.find_each do |m|
        random_people(rand(max_actors_count)).each do |a|
          m.participants.add_actor(a)
        end
        m.participants.add_director(random_person)
        m.save!
      end
    end
    
    def give_awards
      puts "Giving them awards..."
      movie_years.each do |year|
        Award.all.each do |award|
          awarding = Awarding.new(:award => award)
          awarding.requirements.each do |assoc, count|
            case assoc
            when :movies
              awarding.movies = random_movies(year, count)
            when :people
              awarding.people = random_people(count)
            end
          end
          awarding.save!
        end
      end
    end
  end
end
