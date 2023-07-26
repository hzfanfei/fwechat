class Person {

  Person(this.name, this.avatar, this.slogan);

  String name;
  String avatar;
  String slogan;

}

class Constant {

  static const String assetsImages = 'assets/images/';
  static const String assetsAvatar = 'assets/images/avatar/';

  // 联系人信息
  static Map<String, Person> persons = {
    "Emily":Person("Emily", "avataaars(1).png", '世上无难事，只怕有心人'),
    "Ethan":Person("Ethan", "avataaars(2).png", '机会总是留给有准备的人'),
    "Olivia":Person("Olivia", "avataaars(3).png", '勇往直前，永不放弃'),
    "Noah":Person("Noah", "avataaars(4).png", '人生没有彩排，每一天都是现场直播'),
    "Ava":Person("Ava", "avataaars(5).png", '成功源于坚持不懈的努力'),
    "Liam":Person("Liam", "avataaars(6).png", '人生短暂，珍惜每一天'),
    "Sophia":Person("Sophia", "avataaars(7).png", '付出总有回报，只是时间的问题'),
    "Benjamin":Person("Benjamin", "avataaars(8).png", '信念是成功的基石'),
    "Isabella":Person("Isabella", "avataaars(9).png", '人生没有捷径，只有脚踏实地的努力'),
    "Jacob":Person("Jacob", "avataaars(10).png", '梦想是实现的起点，努力是成功的终点'),
  };
}