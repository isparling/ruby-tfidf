class Tfidf
  STOP_WORDS = /(a)|(able)|(about)|(across)|(after)|(all)|(almost)|(also)|(am)|(among)|(an)|(and)|(any)|(are)|(as)|(at)|(be)|(because)|(been)|(but)|(by)|(can)|(cannot)|(could)|(dear)|(did)|(do)|(does)|(either)|(else)|(ever)|(every)|(for)|(from)|(get)|(got)|(had)|(has)|(have)|(he)|(her)|(hers)|(him)|(his)|(how)|(however)|(i)|(if)|(in)|(into)|(is)|(it)|(its)|(just)|(least)|(let)|(like)|(likely)|(may)|(me)|(might)|(most)|(must)|(my)|(neither)|(no)|(nor)|(not)|(of)|(off)|(often)|(on)|(only)|(or)|(other)|(our)|(own)|(rather)|(said)|(say)|(says)|(she)|(should)|(since)|(so)|(some)|(than)|(that)|(the)|(their)|(them)|(then)|(there)|(these)|(they)|(this)|(tis)|(to)|(too)|(twas)|(us)|(wants)|(was)|(we)|(were)|(what)|(when)|(where)|(which)|(while)|(who)|(whom)|(why)|(will)|(with)|(would)|(yet)|(you)|(your)/
  
  def initialize(docs)
    @term_freqs = Hash.new(0)
    @doc_freqs = Hash.new(0)
    @idf = Hash.new(0)
    @num_docs = docs.size
    
    cleaned_docs = prep_messages(docs, :remove_stop_words => false)
    tf(cleaned_docs)
    puts @term_freqs.inspect
    idf
    puts @term_freqs.inspect
    puts '------------------'
  end
  
  
  #clean messages
  #remove stop words (not strictly needod for tf/idf, but might interest people)
  #split on whitespace, join into an array of indiv words.
  def prep_messages(docs, options = {})
    options.merge({:remove_stop_words => true})
    cleaned_docs = []
    docs.each do |doc|
      if options[:remove_stop_words]        
        cleaned_docs << doc.gsub(',.').gsub(STOP_WORDS, '').split('\s')
      else
        #puts doc
        splits = doc.gsub(/,|\./,'').split(/\s+/)
        cleaned_docs << splits
      end
    end
    cleaned_docs
  end
  
  
  def term_count_per_doc(doc)
    doc.inject(Hash.new(0)){|freqs, word|freqs[word] +=1 }
  end
  
  #this isn't perfectly clear in the name of efficiency;
  #could easily do these calculations once for TF and once for DF
  #but no need to do 2n work when n work suffices.
  def tf(docs)
    doc_freq = Hash.new(0) #this gets cleared for each doc
    #puts docs
    docs.each do |doc|
      doc.each do |word|
        @term_freqs[word] += 1 #calculate term frequencies
        doc_freq[word] += 1
      end
      
      #count how many documents contain just *one* instance of any given word
      doc_freq.each do |word, freq|
        @doc_freqs[word] += 1
      end
      
      #reset for the next iteration
      doc_freq.clear
    end
  end
  
  def idf
    @doc_freqs.each do |word, df|
      @idf[word] = Math.log(1.0*@num_docs / @doc_freqs[word]) #do the idf calculation
    end
  end
  
  def tfidf(word)
    term_freq = @term_freqs[word]
    idf = @idf[word]
    
    1.0 * term_freq / idf
  end
end


data = open('data.txt').read
data = data.split('||')
foo = Tfidf.new(data)
puts foo.tfidf('excepturi')
