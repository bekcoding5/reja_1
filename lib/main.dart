import 'dart:async';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

enum Language { uz, en, ru }

Map<Language, Map<String, String>> localizedStrings = {
  Language.uz: {
    'title': 'Kunlik Reja',
    'plans': 'Rejalar',
    'add': 'Qo‘shish',
    'enter_plan': 'Reja yozing',
    'save': 'Saqlash',
    'language': 'Til',
    'delete_completed': 'Bajarilganlarni o‘chirish',
    'no_completed': 'Bajarilgan rejalar yo‘q',
    'delete': 'O‘chirish',
    'select_time': 'Vaqt tanlash',
    'pomodoro_count': 'Pomodoro soni',
    'no_time_selected': 'Vaqt tanlanmagan',
    'start_pomodoro': 'Pomodoro boshlash',
    'pomodoro_timer': 'Pomodoro Taymeri',
    'day_mode': 'Kun rejimi',
    'night_mode': 'Tun rejimi',
    'set_minutes': 'Daqiqalarni kiriting',
    'enter_minutes': 'Daqiqalarni kiriting va Enter ni bosing',
  },
  Language.en: {
    'title': 'Daily Planner',
    'plans': 'Plans',
    'add': 'Add',
    'enter_plan': 'Enter plan',
    'save': 'Save',
    'language': 'Language',
    'delete_completed': 'Delete completed',
    'no_completed': 'No completed plans',
    'delete': 'Delete',
    'select_time': 'Select time',
    'pomodoro_count': 'Pomodoro count',
    'no_time_selected': 'No time selected',
    'start_pomodoro': 'Start Pomodoro',
    'pomodoro_timer': 'Pomodoro Timer',
    'day_mode': 'Day Mode',
    'night_mode': 'Night Mode',
    'set_minutes': 'Set minutes',
    'enter_minutes': 'Enter minutes and press Enter',
  },
  Language.ru: {
    'title': 'Ежедневный план',
    'plans': 'Планы',
    'add': 'Добавить',
    'enter_plan': 'Введите план',
    'save': 'Сохранить',
    'language': 'Язык',
    'delete_completed': 'Удалить завершённые',
    'no_completed': 'Нет завершённых планов',
    'delete': 'Удалить',
    'select_time': 'Выберите время',
    'pomodoro_count': 'Количество Помодоро',
    'no_time_selected': 'Время не выбрано',
    'start_pomodoro': 'Начать Помодоро',
    'pomodoro_timer': 'Таймер Помодоро',
    'day_mode': 'Дневной режим',
    'night_mode': 'Ночной режим',
    'set_minutes': 'Введите минуты',
    'enter_minutes': 'Введите минуты и нажмите Enter',
  },
};

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Language _lang = Language.uz;
  bool isDarkMode = false;

  void toggleLanguage(Language lang) {
    setState(() {
      _lang = lang;
    });
  }

  void toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pomodoro Planner',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        lang: _lang,
        isDarkMode: isDarkMode,
        onLanguageChanged: toggleLanguage,
        onThemeChanged: toggleTheme,
      ),
    );
  }
}

class Task {
  String title;
  TimeOfDay? time;
  int pomodoroCount;
  bool completed;

  Task({
    required this.title,
    this.time,
    this.pomodoroCount = 1,
    this.completed = false,
  });
}

class HomePage extends StatefulWidget {
  final Language lang;
  final bool isDarkMode;
  final ValueChanged<Language> onLanguageChanged;
  final ValueChanged<bool> onThemeChanged;

  HomePage({
    required this.lang,
    required this.isDarkMode,
    required this.onLanguageChanged,
    required this.onThemeChanged,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Language _lang;
  late bool isDarkMode;
  List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    _lang = widget.lang;
    isDarkMode = widget.isDarkMode;
  }

  void _addTaskDialog() {
    TextEditingController _controller = TextEditingController();
    TimeOfDay? selectedTime;
    int pomodoros = 1;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
            left: 16,
            right: 16,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 12,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: StatefulBuilder(
                builder: (context, setStateModal) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        localizedStrings[_lang]!['enter_plan']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.purple,
                        ),
                      ),
                      SizedBox(height: 12),
                      TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          labelText: localizedStrings[_lang]!['enter_plan']!,
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 12),
                      GestureDetector(
                        onTap: () async {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setStateModal(() => selectedTime = time);
                          }
                        },
                        child: Row(
                          children: [
                            Icon(Icons.access_time, color: Colors.purple),
                            SizedBox(width: 8),
                            Text(
                              selectedTime == null
                                  ? localizedStrings[_lang]!['no_time_selected']!
                                  : selectedTime!.format(context),
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(Icons.timer, color: Colors.purple),
                          SizedBox(width: 8),
                          Text(
                            "${localizedStrings[_lang]!['pomodoro_count']!}: ",
                          ),
                          DropdownButton<int>(
                            value: pomodoros,
                            items: List.generate(
                              8,
                              (index) => DropdownMenuItem<int>(
                                value: index + 1,
                                child: Text("${index + 1}"),
                              ),
                            ),
                            onChanged: (val) {
                              setStateModal(() => pomodoros = val!);
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () {
                          if (_controller.text.isEmpty) return;
                          setState(() {
                            tasks.add(
                              Task(
                                title: _controller.text,
                                time: selectedTime,
                                pomodoroCount: pomodoros,
                              ),
                            );
                          });
                          Navigator.of(context).pop();
                        },
                        child: Text(
                          localizedStrings[_lang]!['save']!.toUpperCase(),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }

  void _deleteCompleted() {
    bool any = tasks.any((t) => t.completed);
    if (!any) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizedStrings[_lang]!['no_completed']!),
          backgroundColor: Colors.purple,
        ),
      );
      return;
    }
    setState(() {
      tasks.removeWhere((t) => t.completed);
    });
  }

  void _openPomodoro(Task task) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => PomodoroPage(task: task, lang: _lang)),
    );
  }

  @override
  Widget build(BuildContext context) {
    var strings = localizedStrings[_lang]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings['title']!),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            onPressed: _deleteCompleted,
            icon: Icon(Icons.delete_forever),
            tooltip: strings['delete_completed'],
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.purple),
              child: Center(
                child: Text(
                  strings['language']!,
                  style: TextStyle(color: Colors.white, fontSize: 22),
                ),
              ),
            ),
            ...Language.values.map((lang) {
              return ListTile(
                title: Text(localizedStrings[lang]!['title']!),
                selected: _lang == lang,
                onTap: () {
                  widget.onLanguageChanged(lang);
                  setState(() {
                    _lang = lang;
                  });
                  Navigator.pop(context);
                },
              );
            }).toList(),
            Divider(),
            ListTile(
              leading: Icon(isDarkMode ? Icons.nights_stay : Icons.wb_sunny),
              title: Text(
                isDarkMode ? strings['night_mode']! : strings['day_mode']!,
              ),
              trailing: Switch(
                value: isDarkMode,
                onChanged: (val) {
                  widget.onThemeChanged(val);
                  setState(() {
                    isDarkMode = val;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: tasks.length,
        itemBuilder: (_, i) {
          final task = tasks[i];
          return Card(
            child: ListTile(
              leading: Checkbox(
                value: task.completed,
                activeColor: Colors.purple,
                onChanged: (val) {
                  setState(() {
                    task.completed = val!;
                  });
                },
              ),
              title: Text(task.title),
              subtitle: Row(
                children: [
                  if (task.time != null)
                    Row(
                      children: [
                        Icon(Icons.access_time, size: 16),
                        SizedBox(width: 4),
                        Text(task.time!.format(context)),
                      ],
                    ),
                  SizedBox(width: 10),
                  Icon(Icons.timer, size: 16),
                  Text(" x${task.pomodoroCount}"),
                ],
              ),
              trailing: PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.purple),
                onSelected: (value) {
                  if (value == 'delete') {
                    setState(() {
                      tasks.removeAt(i);
                    });
                  } else if (value == 'start') {
                    _openPomodoro(task);
                  }
                },
                itemBuilder:
                    (_) => [
                      PopupMenuItem(
                        value: 'start',
                        child: Row(
                          children: [
                            Icon(Icons.play_circle, color: Colors.purple),
                            SizedBox(width: 8),
                            Text(strings['start_pomodoro']!),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, color: Colors.red),
                            SizedBox(width: 8),
                            Text(strings['delete']!),
                          ],
                        ),
                      ),
                    ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addTaskDialog,
        backgroundColor: Colors.purple,
        child: Icon(Icons.add),
      ),
    );
  }
}

class PomodoroPage extends StatefulWidget {
  final Task task;
  final Language lang;

  const PomodoroPage({required this.task, required this.lang});

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage> {
  late int timeInMinutes;
  late int remainingSeconds;
  Timer? _timer;
  bool isRunning = false;

  @override
  void initState() {
    super.initState();
    timeInMinutes = widget.task.pomodoroCount * 25;
    remainingSeconds = timeInMinutes * 60;
  }

  void _startTimer() {
    if (_timer != null) return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _stopTimer();
          // Optionally: show some notification or sound here
        }
      });
    });

    setState(() {
      isRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;

    setState(() {
      isRunning = false;
    });
  }

  void _resetTimer() {
    _stopTimer();
    setState(() {
      remainingSeconds = timeInMinutes * 60;
    });
  }

  void _increaseTime() {
    if (isRunning) return;
    setState(() {
      timeInMinutes++;
      remainingSeconds = timeInMinutes * 60;
    });
  }

  void _decreaseTime() {
    if (isRunning || timeInMinutes <= 1) return;
    setState(() {
      timeInMinutes--;
      remainingSeconds = timeInMinutes * 60;
    });
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;
    int seconds = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    var strings = localizedStrings[widget.lang]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(strings['pomodoro_timer']!),
        backgroundColor: Colors.purple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF8E24AA)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.task.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white24),
              ),
              child: Text(
                _formatTime(remainingSeconds),
                style: const TextStyle(
                  fontSize: 80,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildIconButton(Icons.remove, _decreaseTime),
                const SizedBox(width: 20),
                Text(
                  '$timeInMinutes min',
                  style: const TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 20),
                _buildIconButton(Icons.add, _increaseTime),
              ],
            ),
            Column(
              children: [
                ElevatedButton(
                  onPressed: isRunning ? _stopTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 50,
                      vertical: 15,
                    ),
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 10,
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text(isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: _resetTimer,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white70,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIconButton(IconData icon, VoidCallback onPressed) {
    return GestureDetector(
      onTap: isRunning ? null : onPressed,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const LinearGradient(
            colors: [Colors.deepPurpleAccent, Colors.purpleAccent],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.6),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Icon(icon, color: Colors.white, size: 32),
      ),
    );
  }
}
