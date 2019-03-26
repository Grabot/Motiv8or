package motivator.app.grabot.motiv8or.activities

import android.content.Intent
import android.os.Bundle
import android.support.design.widget.TextInputEditText
import android.support.design.widget.TextInputLayout
import android.support.v4.widget.NestedScrollView
import android.support.v7.app.AppCompatActivity
import android.support.v7.widget.AppCompatButton
import android.support.v7.widget.AppCompatTextView
import android.view.View
import motivator.app.grabot.motiv8or.R
import motivator.app.grabot.motiv8or.support.InputValidation
import android.widget.Toast
import android.os.AsyncTask
import org.json.JSONException
import org.json.JSONObject
import java.io.IOException
import java.net.HttpURLConnection
import java.net.MalformedURLException
import java.net.URL


class RegisterActivity : AppCompatActivity(), View.OnClickListener {

    private val activity = this@RegisterActivity

    private lateinit var nestedScrollView: NestedScrollView

    private lateinit var textInputLayoutName: TextInputLayout
    private lateinit var textInputLayoutEmail: TextInputLayout
    private lateinit var textInputLayoutPassword: TextInputLayout
    private lateinit var textInputLayoutConfirmPassword: TextInputLayout

    private lateinit var textInputEditTextName: TextInputEditText
    private lateinit var textInputEditTextEmail: TextInputEditText
    private lateinit var textInputEditTextPassword: TextInputEditText
    private lateinit var textInputEditTextConfirmPassword: TextInputEditText

    private lateinit var appCompatButtonRegister: AppCompatButton
    private lateinit var appCompatTextViewLoginLink: AppCompatTextView

    private lateinit var inputValidation: InputValidation

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        setContentView(R.layout.activity_register)
        supportActionBar!!.hide()

        initViews()
        initListeners()
        initObjects()
    }

    private fun initViews() {
        nestedScrollView = findViewById<View>(R.id.nestedScrollViewRegister) as NestedScrollView
        textInputLayoutName = findViewById<View>(R.id.textInputLayoutName) as TextInputLayout
        textInputLayoutEmail = findViewById<View>(R.id.textInputLayoutEmail) as TextInputLayout
        textInputLayoutPassword = findViewById<View>(R.id.textInputLayoutPassword) as TextInputLayout
        textInputLayoutConfirmPassword = findViewById<View>(R.id.textInputLayoutConfirmPassword) as TextInputLayout
        textInputEditTextName = findViewById<View>(R.id.textInputEditTextName) as TextInputEditText
        textInputEditTextEmail = findViewById<View>(R.id.textInputEditTextEmail) as TextInputEditText
        textInputEditTextPassword = findViewById<View>(R.id.textInputEditTextPassword) as TextInputEditText
        textInputEditTextConfirmPassword = findViewById<View>(R.id.textInputEditTextConfirmPassword) as TextInputEditText
        appCompatButtonRegister = findViewById<View>(R.id.appCompatButtonRegister) as AppCompatButton
        appCompatTextViewLoginLink = findViewById<View>(R.id.appCompatTextViewLoginLink) as AppCompatTextView
    }

    private fun initListeners() {
        appCompatButtonRegister.setOnClickListener(this)
        appCompatTextViewLoginLink.setOnClickListener(this)
    }

    private fun initObjects() {
        inputValidation = InputValidation(activity)
    }

    override fun onClick(v: View) {
        when (v.id) {
            R.id.appCompatButtonRegister -> registerUser()
            R.id.appCompatTextViewLoginLink -> finish()
        }
    }

    private fun registerUser() {
        val Name = textInputEditTextName.text.toString()
        val Password = textInputEditTextPassword.text.toString()
        val Email = textInputEditTextEmail.text.toString()

        val b = BackGround()
        b.execute(Name, Password, Email)
    }

    internal inner class BackGround : AsyncTask<String, String, String>() {

        override fun doInBackground(vararg params: String): String {
            val name = params[0]
            val password = params[1]
            val email = params[2]

            try {
                val url = URL("http://10.0.2.2/motivate/register.php")
                val urlParams = "name=$name&password=$password&email=$email"

                val httpURLConnection = url.openConnection() as HttpURLConnection
                httpURLConnection.doOutput = true

                val os = httpURLConnection.outputStream 
                os.write(urlParams.toByteArray())
                os.flush()
                os.close()

                val input = httpURLConnection.inputStream

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
            try {
                val root = JSONObject(s)
                val user_data = root.getJSONObject("user_data")
                var result = user_data.getString("result")
                if (result == "failed") {
                    succes = false
                }
            } catch (e: JSONException) {
                e.printStackTrace()
                succes = false
            }

            if (succes) {
                val intentLogin = Intent(applicationContext, LoginActivity::class.java)
                startActivity(intentLogin)
            } else {
                Toast.makeText(this@RegisterActivity, "Are you sure lol? this didn't work!", Toast.LENGTH_SHORT).show()
            }
        }
    }
}