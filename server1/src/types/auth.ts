import * as Yup from "yup";

export const SignInSchema = Yup.object().shape({
  email: Yup.string()
    .email("Invalid email address")
    .required("Email is required"),
  password: Yup.string().required("No password provided."),
});

export const SignUpSchema = Yup.object().shape({
  username: Yup.string()
    .matches(/^(?:[A-Za-z]+)(?:\s[A-Za-z]+){1,2}$/, "Provide your 2 or 3 Names")
    .max(100, "Too Long!")
    .required("First name is Required"),
  email: Yup.string()
    .email("Invalid email address")
    .required("Email is required"),
  password: Yup.string()
    .required("No password provided.")
    .min(8, "Password is too short - should be 8 chars minimum.")
    .matches(
      /^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[#?!@$%^&*-])[A-Za-z\d#?!@$%^&*-]{8,}$/,
      "Password should include small, big and spcial characters"
    ),
});
