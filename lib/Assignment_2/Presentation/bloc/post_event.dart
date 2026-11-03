abstract class PostEvent {} //ye class event ka base class hai, jismein separate events kodefine karenge jo post ke liye use honge

class LoadPostsEvent extends PostEvent {} // class jo ke post ko load karne ke liye use hogaa, sublcass hai postevent ki