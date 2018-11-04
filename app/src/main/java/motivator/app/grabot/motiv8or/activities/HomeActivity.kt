package motivator.app.grabot.motiv8or.activities

import android.os.Bundle
import android.support.v7.app.AppCompatActivity
import android.widget.ListView
import android.widget.Toast
import motivator.app.grabot.motiv8or.R
import motivator.app.grabot.motiv8or.adapters.CustomAdapter
import motivator.app.grabot.motiv8or.data.Model

class HomeActivity : AppCompatActivity() {

    private var lv: ListView? = null
    private var customAdapter: CustomAdapter? = null
    private val feedList = arrayOf(
        "Routine 1",
        "Routine 2",
        "News over Trump",
        "Foto van Sander de developer",
        "Donatie mogelijkheid voor Sander",
        "Sander",
        "Sander's fiets",
        "Sander tijdens de lunch")

    private val model: ArrayList<Model>
        get() {
            val list = ArrayList<Model>()
            for (i in 0..7) {

                val model = Model()
                model.setNumbers(1)
                model.setFeed(feedList[i])
                list.add(model)
            }
            return list
        }

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_home)

        val name = getIntent().getStringExtra("name")
        val password = getIntent().getStringExtra("password")
        val email = getIntent().getStringExtra("email")

        lv = findViewById(R.id.lv) as ListView

        modelArrayList = model
        customAdapter = CustomAdapter(this)
        lv!!.adapter = customAdapter

        Toast.makeText(this@HomeActivity, "Welcome " + name + " your password was " + password +
                ", don't tell anyone!\nWe're telling you so we don't have to send an email to " + email +
                " if you do forget it.", Toast.LENGTH_SHORT).show()
    }

    companion object {
        lateinit var modelArrayList: ArrayList<Model>
    }
}