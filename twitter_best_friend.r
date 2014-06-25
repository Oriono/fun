# use twitter API to get a public account's most @ friends in wordcloud. 

library(RCurl)
# Set SSL certs globally
options(RCurlOptions = list(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl")))
 
require(twitteR)
reqURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

#Twitter API credentials
apiKey <- "your key here"
apiSecret <- "your secret here"
 
twitCred <- OAuthFactory$new(consumerKey=apiKey,consumerSecret=apiSecret,requestURL=reqURL,accessURL=accessURL,authURL=authURL)
 
twitCred$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))



registerTwitterOAuth(twitCred)

library(twitteR)
library(tm)
library(wordcloud)
library(RColorBrewer)


#this method can only access most recent 3500 tweets. 
timeline=userTimeline('Public twitter user name here',n=2000)
tl_text = sapply(timeline, function(x) x$getText())

#only get user name with format like @alnum  alpha beta number
name <- "@([[:alnum:]]+)"
tl_user<-str_extract_all(tl_text,name)
timln_corpus = Corpus(VectorSource(tl_user))
tdm = TermDocumentMatrix(
timln_corpus,
control = list(
removePunctuation = TRUE,
stopwords = stopwords("english"),
removeNumbers = TRUE, tolower = TRUE)
)
m = as.matrix(tdm)
# get word counts in decreasing order
word_freqs = sort(rowSums(m), decreasing = TRUE)
# create a data frame with words and their frequencies
dm = data.frame(word = names(word_freqs), freq = word_freqs)
wordcloud(dm$word, dm$freq, random.order = FALSE, colors = brewer.pal(8, "Dark2"))
