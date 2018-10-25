package motivator.app.grabot.motiv8or

import android.content.Intent
import android.support.v7.app.AppCompatActivity
import android.os.Bundle
import android.support.v7.widget.AppCompatButton
import android.support.v7.widget.AppCompatTextView
import android.view.View
import motivator.app.grabot.motiv8or.activities.HomeActivity
import motivator.app.grabot.motiv8or.activities.LoginActivity
import motivator.app.grabot.motiv8or.activities.RegisterActivity

class MainActivity : AppCompatActivity(), View.OnClickListener {

    private val activity = this@MainActivity

    private lateinit var appCompatButtonLoginMain: AppCompatButton
    private lateinit var textViewLinkRegisterMain: AppCompatTextView
    private lateinit var textViewContinueAsGuest : AppCompatTextView

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)

        initViews()
        initListeners()
    }

    private fun initViews() {
        appCompatButtonLoginMain = findViewById<View>(R.id.appCompatButtonLoginMain) as AppCompatButton
        textViewLinkRegisterMain = findViewById<View>(R.id.textViewCreateAccountMain) as AppCompatTextView
        textViewContinueAsGuest = findViewById<View>(R.id.textViewContinueAsGuest) as AppCompatTextView
    }

    private fun initListeners() {
        appCompatButtonLoginMain.setOnClickListener(this)
        textViewLinkRegisterMain.setOnClickListener(this)
        textViewContinueAsGuest.setOnClickListener(this)
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.appCompatButtonLoginMain -> {
                val intentLogin = Intent(activity, LoginActivity::class.java)
                startActivity(intentLogin)
            }
            R.id.textViewCreateAccountMain -> {
                val intentRegister = Intent(activity, RegisterActivity::class.java)
                startActivity(intentRegister)
            }
            R.id.textViewContinueAsGuest -> {
                val intentHome = Intent(activity, HomeActivity::class.java)
                startActivity(intentHome)
            }
        }
    }

}
