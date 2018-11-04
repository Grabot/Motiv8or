package motivator.app.grabot.motiv8or.activities

import android.content.Intent
import android.os.AsyncTask
import android.os.Bundle
import android.support.design.widget.TextInputEditText
import android.support.design.widget.TextInputLayout
import android.support.v4.widget.NestedScrollView
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.AppCompatButton
import android.support.v7.widget.AppCompatTextView
import android.view.View
import motivator.app.grabot.motiv8or.R
import motivator.app.grabot.motiv8or.sql.DatabaseHelper
import motivator.app.grabot.motiv8or.support.InputValidation
import java.io.IOException
import java.net.HttpURLConnection
import java.net.MalformedURLException
import java.net.URL
import org.json.JSONException
import org.json.JSONObject
import android.widget.Toast


class LoginActivity : AppCompatActivity(), View.OnClickListener {

    private val activity = this@LoginActivity

    private lateinit var nestedScrollView: NestedScrollView
    private lateinit var textInputLayoutEmail: TextInputLayout
    private lateinit var textInputLayoutPassword: TextInputLayout
    private lateinit var textInputEditTextEmail: TextInputEditText
    private lateinit var textInputEditTextPassword: TextInputEditText
    private lateinit var appCompatButtonLogin: AppCompatButton
    private lateinit var textViewLinkRegister: AppCompatTextView
    private lateinit var inputValidation: InputValidation
    private lateinit var databaseHelper: DatabaseHelper

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_login)
        supportActionBar!!.hide()

        initViews()
        initListeners()
        initObjects()
    }

    private fun initViews() {
        nestedScrollView = findViewById<View>(R.id.nestedScrollViewLogin) as NestedScrollView
        textInputLayoutEmail = findViewById<View>(R.id.textInputLayoutEmail) as TextInputLayout
        textInputLayoutPassword = findViewById<View>(R.id.textInputLayoutPassword) as TextInputLayout
        textInputEditTextEmail = findViewById<View>(R.id.textInputEditTextEmail) as TextInputEditText
        textInputEditTextPassword = findViewById<View>(R.id.textInputEditTextPassword) as TextInputEditText
        appCompatButtonLogin = findViewById<View>(R.id.appCompatButtonLogin) as AppCompatButton
        textViewLinkRegister = findViewById<View>(R.id.textViewLinkRegister) as AppCompatTextView
    }

    private fun initListeners() {
        appCompatButtonLogin.setOnClickListener(this)
        textViewLinkRegister.setOnClickListener(this)
    }

    private fun initObjects() {
        databaseHelper = DatabaseHelper(activity)
        inputValidation = InputValidation(activity)
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.appCompatButtonLogin -> verifyUserAndLogin()
            R.id.textViewLinkRegister -> {
                val intentRegister = Intent(applicationContext, RegisterActivity::class.java)
                startActivity(intentRegister)
            }
        }
    }

    private fun verifyUserAndLogin() {
        val Name = textInputEditTextEmail.text.toString()
        val Password = textInputEditTextPassword.text.toString()

        val b = BackGround()
        b.execute(Name, Password)
    }

    internal inner class BackGround : AsyncTask<String, String, String>() {
        override fun doInBackground(vararg params: String?): String {
            val name = params[0]
            val password = params[1]

            try {
                // 10.0.2.2 is how you can access localhost on the host computer of the emulator
                // We use the localhost before getting it to work on a real server.
                val url = URL("http://10.0.2.2/motivate/login.php")
                val urlParams = "name=$name&password=$password"

                val httpURLConnection = url.openConnection() as HttpURLConnection
                httpURLConnection.setDoOutput(true)

                val os = httpURLConnection.getOutputStream()
                os.write(urlParams.toByteArray())
                os.flush()
                os.close()

                val input = httpURLConnection.getInputStream()

                val data = input.bufferedReader().readText()

                input.close()
                httpURLConnection.disconnect()

                return data

            } catch (e: MalformedURLException) {
                e.printStackTrace()
                return "Exception: " + e.message
            } catch (e: IOException) {
                e.printStackTrace()
                return "Exception: " + e.message
            }

        }

        override fun onPostExecute(s: String) {
            var succes = true
            var name = ""
            var password = ""
            var email = ""
            try {
                val root = JSONObject(s)
                val user_data = root.getJSONObject("user_data")
                name = user_data.getString("name")
                password = user_data.getString("password")
                email = user_data.getString("email")
            } catch (e: JSONException) {
                e.printStackTrace()
                succes = false
            }

            if (succes) {
                val intentLogin = Intent(applicationContext, HomeActivity::class.java)
                intentLogin.putExtra("name", name)
                intentLogin.putExtra("password", password)
                intentLogin.putExtra("email", email)
                startActivity(intentLogin)
            } else {
                Toast.makeText(this@LoginActivity, "Username or password was incorrect!", Toast.LENGTH_SHORT).show()
            }
        }
    }
}
