module Attentive
  CONTRACTIONS = {"ain't"=>["am not"], "aren't"=>["are not"], "can't"=>["can not"], "cannot"=>["can not"], "could've"=>["could have"], "couldn't"=>["could not"], "couldn't've"=>["could not have"], "didn't"=>["did not"], "doesn't"=>["does not"], "don't"=>["do not"], "hadn't"=>["had not"], "hadn't've"=>["had not have"], "hasn't"=>["has not"], "haven't"=>["have not"], "he'd"=>["he had", "he would"], "he'd've"=>["he would have"], "he'll"=>["he will", "he shall"], "he's"=>["he is", "he has"], "he'sn't"=>["he is not", "he has not"], "how'd"=>["how did", "how would"], "how'll"=>["how will"], "how's"=>["how is", "how has", "how does"], "i'd"=>["i would", "i had"], "i'd've"=>["i would have"], "i'll"=>["i shall", "i will"], "i'm"=>["i am"], "i've"=>["i have"], "i'ven't"=>["i have not"], "isn't"=>["is not"], "it'd"=>["it would", "it had"], "it'd've"=>["it would have"], "it'll"=>["it will", "it shall"], "it's"=>["it is", "it has"], "it'sn't"=>["it is not", "it has not"], "let's"=>["let us"], "ma'am"=>["madam"], "mightn't"=>["might not"], "mightn't've"=>["might not have"], "might've"=>["might have"], "mustn't"=>["must not"], "must've"=>["must have"], "needn't"=>["need not"], "not've"=>["not have"], "o'clock"=>["of the clock"], "oughtn't"=>["ought not"], "shan't"=>["shall not"], "she'd"=>["she had", "she would"], "she'd've"=>["she would have"], "she'll"=>["she shall", "she will"], "she's"=>["she is", "she has"], "she'sn't"=>["she is not", "she has not"], "should've"=>["should have"], "shouldn't"=>["should not"], "shouldn't've"=>["should not have"], "somebody'd"=>["somebody had", "somebody would"], "somebody'd've"=>["somebody would have"], "somebody'dn't've"=>["somebody would not have"], "somebody'll"=>["somebody shall", "somebody will"], "somebody's"=>["somebody is", "somebody has"], "someone'd"=>["someone had", "someone would"], "someone'd've"=>["someone would have"], "someone'll"=>["someone shall", "someone will"], "someone's"=>["someone is", "someone has"], "something'd"=>["something had", "something would"], "something'd've"=>["something would have"], "something'll"=>["something shall", "something will"], "something's"=>["something is", "something has"], "that'll"=>["that will"], "that's"=>["that is", "that has"], "there'd"=>["there had", "there would"], "there'd've"=>["there would have"], "there're"=>["there are"], "there's"=>["there is", "there has"], "they'd"=>["they would", "they had"], "they'dn't"=>["they would not"], "they'dn't've"=>["they would not have"], "they'd've"=>["they would have"], "they'd'ven't"=>["they would have not"], "they'll"=>["they shall", "they will"], "they'lln't've"=>["they will not have"], "they'll'ven't"=>["they will have not"], "they're"=>["they are"], "they've"=>["they have"], "they'ven't"=>["they have not"], "'tis"=>["it is"], "'twas"=>["it was"], "wasn't"=>["was not"], "we'd"=>["we had", "we would"], "we'd've"=>["we would have"], "we'dn't've"=>["we would not have"], "we'll"=>["we will"], "we'lln't've"=>["we will not have"], "we're"=>["we are"], "we've"=>["we have"], "weren't"=>["were not"], "what'll"=>["what shall", "what will"], "what're"=>["what are"], "what's"=>["what is", "what does", "what has"], "what've"=>["what have"], "when's"=>["when is", "when has"], "where'd"=>["where did"], "where's"=>["where is", "where does", "where has"], "where've"=>["where have"], "who'd"=>["who would", "who had"], "who'd've"=>["who would have"], "who'll"=>["who shall", "who will"], "who're"=>["who are"], "who's"=>["who is", "who has"], "who've"=>["who have"], "why'll"=>["why will"], "why're"=>["why are"], "why's"=>["why is", "why has"], "won't"=>["will not"], "won't've"=>["will not have"], "would've"=>["would have"], "wouldn't"=>["would not"], "wouldn't've"=>["would not have"], "y'all"=>["you all"], "y'all'd've"=>["you all would have"], "y'all'dn't've"=>["you all would not have"], "y'all'll"=>["you all will"], "y'all'lln't"=>["you all will not"], "y'all'll've"=>["you all will have"], "y'all'll'ven't"=>["you all will have not"], "you'd"=>["you had", "you would"], "you'd've"=>["you would have"], "you'll"=>["you shall", "you will"], "you're"=>["you are"], "you'ren't"=>["you are not"], "you've"=>["you have"], "you'ven't"=>["you have not"]}.freeze
end
