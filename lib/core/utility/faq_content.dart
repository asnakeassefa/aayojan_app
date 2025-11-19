class Content {
  String title;
  String content;

  Content({
    required this.title,
    required this.content,
  });
}

List<Content> faqContent = [
  Content(
    title: "What is Aayojan?",
    content:
        "Aayojan is an event management app that helps you plan, organize, and track events seamlessly. From sending invitations to managing RSVPs and seating arrangements, everything is handled in one place.",
  ),
  Content(
    title: "How do I create an event?",
    content:
        "To create an event, log in to your Aayojan account, navigate to the 'Create Event' section, and fill out the required details such as event type, date, and location. You can then browse and select vendors and venues that suit your needs.",
  ),
  Content(
    title: "Can I send digital invitations?",
    content:
        "Yes, Aayojan allows you to send digital invitations to your guests via email or SMS. You can customize the invitation template and track RSVPs directly through the app.",
  ),
  Content(
    title: "How can I track RSVPs?",
    content:
        "Once you send out invitations, you can track RSVPs in real-time. Guests can respond directly through the invitation link, and you will receive notifications for each response.",
  ),
  Content(
    title: "Is there a way to manage guests?",
    content:
        "Yes, Aayojan provides a guest management feature that allows you to add, edit, and remove guests from your event list. You can also categorize guests into different groups for better organization.",
  ),
  Content(
    title: "Is Aayojan free to use?",
    content:
        "Aayojan offers a free version with basic features. For advanced functionalities and premium services, you can opt for our subscription plans.",
  ),
];
