package com.fubo.sportsbook.v3;

import android.app.Activity;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;
import java.util.TimeZone;

import org.junit.Rule;
import org.junit.Test;
import org.junit.runner.RunWith;

import androidx.test.espresso.action.ViewActions;
import androidx.test.espresso.matcher.ViewMatchers;
import androidx.test.ext.junit.rules.ActivityScenarioRule;
import androidx.test.ext.junit.runners.AndroidJUnit4;
import androidx.test.filters.LargeTest;
import androidx.test.rule.GrantPermissionRule;

import static androidx.test.espresso.Espresso.onView;
import static androidx.test.espresso.action.ViewActions.click;
import static androidx.test.espresso.action.ViewActions.closeSoftKeyboard;
import static androidx.test.espresso.action.ViewActions.typeText;
import static androidx.test.espresso.assertion.ViewAssertions.matches;

import static androidx.test.espresso.matcher.ViewMatchers.isClickable;
import static androidx.test.espresso.matcher.ViewMatchers.isDisplayed;
import static androidx.test.espresso.matcher.ViewMatchers.isEnabled;

import static androidx.test.espresso.matcher.ViewMatchers.withId;
import static androidx.test.espresso.matcher.ViewMatchers.withContentDescription;
import static androidx.test.espresso.matcher.ViewMatchers.withResourceName;
import static androidx.test.espresso.matcher.ViewMatchers.withText;

import static org.hamcrest.Matchers.not;

import com.fubo.sportsbook.v3.Helpers;

/**
 * Basic tests showcasing simple view matchers and actions like {@link ViewMatchers#withId},
 * {@link ViewActions#click} and {@link ViewActions#typeText}.
 * <p>
 * Note that there is no need to tell Espresso that a view is in a different {@link Activity}.
 */
@RunWith(AndroidJUnit4.class)
@LargeTest
public class TLS215485Test {

    public static String fuboSBPasswordGenerator() {
        String frontHalfOfPassword = "FuboTV#";

        Date today = new Date();
        DateFormat dateFormat = new SimpleDateFormat("yyyyMMdd");
        //The Testing env is using london server time for the passwords
        dateFormat.setTimeZone(TimeZone.getTimeZone("Europe/London"));
        String londonDate = dateFormat.format(today);
        return frontHalfOfPassword + londonDate;
    }

    public static StringBuilder generatePhoneNumber() {
        StringBuilder currentNumbers = new StringBuilder();
        StringBuilder phoneNumber = new StringBuilder();
        Random rand = new Random();
        for (int i = 0; i < 4; i++) {
            int randomInt = rand.nextInt(10);
            currentNumbers.append(randomInt);
            phoneNumber.append(currentNumbers);
        }
        return phoneNumber;
    }

    @Rule
    public GrantPermissionRule mRuntimePermissionRule = GrantPermissionRule.grant(android.Manifest.permission.ACCESS_FINE_LOCATION);

    /**
     * Use {@link ActivityScenarioRule} to create and launch the activity under test, and close it
     * after test completes. This is a replacement for {@link androidx.test.rule.ActivityTestRule}.
     */
    @Rule public ActivityScenarioRule<MainActivity> activityScenarioRule
            = new ActivityScenarioRule<>(MainActivity.class);


    @Test
    public void TC793() {
        //moved over
        //Verify error message when user attempts login with incorrect credentials
        String Error_Text = "That email and password combination is not valid.";
        Helpers.login("asd@asd.com", Helpers.fuboSBPasswordGenerator());
        onView(withText(Error_Text)).check(matches(isDisplayed()));
    }

    @Test
    public void TC794() {
        //moved over
        ///Verify login button is clickable if both input fields are sufficient
        Helpers.loginWithoutSubmitting("asd@asd.com", Helpers.fuboSBPasswordGenerator());
        onView(withContentDescription("LoginScreen-Login-Button-Touch")).check(matches(isClickable()));
    }

}