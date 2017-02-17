package controllers;

import com.google.i18n.phonenumbers.PhoneNumberToCarrierMapper;
import com.google.i18n.phonenumbers.Phonenumber;
import org.json.HTTP;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.json.JsonObject;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.Locale;


/**
 * Created by Kalana on 2/16/2017.
 */
@WebServlet(name = "getCarrier", urlPatterns = "/")
public class HelloServlet extends HttpServlet {


    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

        PhoneNumberToCarrierMapper pcm = PhoneNumberToCarrierMapper.getInstance();

        Phonenumber.PhoneNumber pn = new Phonenumber.PhoneNumber();

        StringBuffer jb = new StringBuffer();

        String line = null;
        try {
            BufferedReader reader = req.getReader();
            while ((line = reader.readLine()) != null)
                jb.append(line);
        } catch (Exception e) { /*report an error*/ }

        try {
           JSONObject jsonObject =   new JSONObject(jb.toString());

            pn.setCountryCode(Integer.parseInt(jsonObject.get("code").toString()));
            pn.setNationalNumber(Integer.parseInt(jsonObject.get("number").toString()));

            JSONObject respjsonObj = new JSONObject("{\"IsSuccess\":"+true+",\"Carrier\":"+pcm.getNameForNumber(pn, Locale.ENGLISH)+"}");


            res.getWriter().write(respjsonObj.toString());


        } catch (JSONException e) {
            JSONObject respjsonObj = new JSONObject("{\"IsSuccess\":"+false+",\"Carrier\":NULL}");
            res.getWriter().write(respjsonObj.toString());
            //
        }
    }




}

