package motivator.app.grabot.motiv8or.data

class Model {

    var number: Int = 0
    var feedItems: String? = null

    fun getNumbers(): Int {
        return number
    }

    fun setNumbers(number: Int) {
        this.number = number
    }

    fun getFeed(): String {
        return feedItems.toString()
    }

    fun setFeed(feed: String) {
        this.feedItems = feed
    }

}