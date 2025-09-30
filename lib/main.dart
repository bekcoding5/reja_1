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
    'start_pomodoro': 'Pomodoro boshlash',
    'pomodoro_timer': 'Pomodoro',
    'day_mode': 'Kun rejimi',
    'night_mode': 'Tun rejimi',
    'settings': 'Sozlamalar',
    'work_time': 'Ish vaqti (minut)',
    'short_break': 'Qisqa dam olish (minut)',
    'long_break': 'Uzun dam olish (minut)',
    'sessions_before_long': 'Uzun dam oldingi sessiyalar',
    'break_time': 'Dam Olish Vaqti',
    'pomodoro_complete': 'Pomodoro tugadi!',
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
    'start_pomodoro': 'Start Pomodoro',
    'pomodoro_timer': 'Pomodoro',
    'day_mode': 'Day Mode',
    'night_mode': 'Night Mode',
    'settings': 'Settings',
    'work_time': 'Work time (min)',
    'short_break': 'Short break (min)',
    'long_break': 'Long break (min)',
    'sessions_before_long': 'Sessions before long break',
    'break_time': 'Break Time',
    'pomodoro_complete': 'Pomodoro completed!',
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
    'start_pomodoro': 'Начать Помодоро',
    'pomodoro_timer': 'Помодоро',
    'day_mode': 'Дневной режим',
    'night_mode': 'Ночной режим',
    'settings': 'Настройки',
    'work_time': 'Время работы (мин)',
    'short_break': 'Короткий перерыв (мин)',
    'long_break': 'Длинный перерыв (мин)',
    'sessions_before_long': 'Сессии перед длинным перерывом',
    'break_time': 'Время Перерыва',
    'pomodoro_complete': 'Помодоро завершено!',
  },
};

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Language _lang = Language.uz;

  bool isDarkMode = false;

  // Global Pomodoro sozlamalari

  int workTime = 25;

  int shortBreak = 5;

  int longBreak = 15;

  int sessionsBeforeLong = 4;

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

  void updatePomodoroSettings({
    int? newWorkTime,
    int? newShortBreak,
    int? newLongBreak,
    int? newSessionsBeforeLong,
  }) {
    setState(() {
      if (newWorkTime != null) workTime = newWorkTime;

      if (newShortBreak != null) shortBreak = newShortBreak;

      if (newLongBreak != null) longBreak = newLongBreak;

      if (newSessionsBeforeLong != null)
        sessionsBeforeLong = newSessionsBeforeLong;
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
        scaffoldBackgroundColor: Colors.grey[100],
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.purple,
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: Colors.grey[900],
      ),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: HomePage(
        lang: _lang,
        isDarkMode: isDarkMode,
        onLanguageChanged: toggleLanguage,
        onThemeChanged: toggleTheme,
        workTime: workTime,
        shortBreak: shortBreak,
        longBreak: longBreak,
        sessionsBeforeLong: sessionsBeforeLong,
        onSettingsChanged: updatePomodoroSettings,
      ),
    );
  }
}

class Task {
  String title;

  bool completed;

  Task({required this.title, this.completed = false});
}

class HomePage extends StatefulWidget {
  final Language lang;

  final bool isDarkMode;

  final ValueChanged<Language> onLanguageChanged;

  final ValueChanged<bool> onThemeChanged;

  final int workTime;

  final int shortBreak;

  final int longBreak;

  final int sessionsBeforeLong;

  final Function({
    int? newWorkTime,
    int? newShortBreak,
    int? newLongBreak,
    int? newSessionsBeforeLong,
  })
  onSettingsChanged;

  HomePage({
    required this.lang,
    required this.isDarkMode,
    required this.onLanguageChanged,
    required this.onThemeChanged,
    required this.workTime,
    required this.shortBreak,
    required this.longBreak,
    required this.sessionsBeforeLong,
    required this.onSettingsChanged,
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
            top: 16,
          ),
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            elevation: 8,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    localizedStrings[_lang]!['enter_plan']!,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.purple[700],
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: localizedStrings[_lang]!['enter_plan']!,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: Icon(Icons.task, color: Colors.purple),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple[700],
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      if (_controller.text.isEmpty) return;

                      setState(() {
                        tasks.add(Task(title: _controller.text));
                      });

                      Navigator.of(context).pop();
                    },
                    child: Text(
                      localizedStrings[_lang]!['save']!.toUpperCase(),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
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
          backgroundColor: Colors.purple[700],
          duration: Duration(seconds: 2),
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
      MaterialPageRoute(
        builder:
            (_) => PomodoroPage(
              task: task,
              lang: _lang,
              workTime: widget.workTime,
              shortBreak: widget.shortBreak,
              longBreak: widget.longBreak,
              sessionsBeforeLong: widget.sessionsBeforeLong,
            ),
      ),
    );
  }

  void _showSettingsDialog() {
    int tempWorkTime = widget.workTime;

    int tempShortBreak = widget.shortBreak;

    int tempLongBreak = widget.longBreak;

    int tempSessionsBeforeLong = widget.sessionsBeforeLong;

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(localizedStrings[_lang]!['settings']!),
          content: StatefulBuilder(
            builder: (context, setStateModal) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSliderRow(
                    label: localizedStrings[_lang]!['work_time']!,
                    value: tempWorkTime,
                    min: 1,
                    max: 60,
                    onChanged: (val) => setStateModal(() => tempWorkTime = val),
                  ),
                  _buildSliderRow(
                    label: localizedStrings[_lang]!['short_break']!,
                    value: tempShortBreak,
                    min: 1,
                    max: 30,
                    onChanged:
                        (val) => setStateModal(() => tempShortBreak = val),
                  ),
                  _buildSliderRow(
                    label: localizedStrings[_lang]!['long_break']!,
                    value: tempLongBreak,
                    min: 1,
                    max: 60,
                    onChanged:
                        (val) => setStateModal(() => tempLongBreak = val),
                  ),
                  _buildSliderRow(
                    label: localizedStrings[_lang]!['sessions_before_long']!,
                    value: tempSessionsBeforeLong,
                    min: 1,
                    max: 8,
                    onChanged:
                        (val) =>
                            setStateModal(() => tempSessionsBeforeLong = val),
                  ),
                ],
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Bekor qilish'),
            ),
            ElevatedButton(
              onPressed: () {
                widget.onSettingsChanged(
                  newWorkTime: tempWorkTime,
                  newShortBreak: tempShortBreak,
                  newLongBreak: tempLongBreak,
                  newSessionsBeforeLong: tempSessionsBeforeLong,
                );

                Navigator.pop(ctx);
              },
              child: Text(localizedStrings[_lang]!['save']!),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSliderRow({
    required String label,
    required int value,
    required double min,
    required double max,
    required ValueChanged<int> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Slider(
          value: value.toDouble(),
          min: min,
          max: max,
          divisions: (max - min).toInt(),
          label: value.toString(),
          onChanged: (double newValue) => onChanged(newValue.toInt()),
        ),
        Text(value.toString()),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    var strings = localizedStrings[_lang]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings['title']!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        elevation: 0,
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
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.purple[700]!, Colors.purple[400]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  strings['language']!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            ...Language.values.map((lang) {
              String flag;

              switch (lang) {
                case Language.uz:
                  flag = '🇺🇿';

                  break;

                case Language.en:
                  flag = '🇬🇧';

                  break;

                case Language.ru:
                  flag = '🇷🇺';

                  break;
              }

              return ListTile(
                leading: Text(flag, style: TextStyle(fontSize: 24)),
                title: Text(localizedStrings[lang]!['title']!),
                selected: _lang == lang,
                selectedTileColor: Colors.purple[100],
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
              leading: Icon(Icons.settings, color: Colors.purple[700]),
              title: Text(strings['settings']!),
              onTap: () {
                Navigator.pop(context);

                _showSettingsDialog();
              },
            ),
            ListTile(
              leading: Icon(
                isDarkMode ? Icons.nights_stay : Icons.wb_sunny,
                color: Colors.purple[700],
              ),
              title: Text(
                isDarkMode ? strings['night_mode']! : strings['day_mode']!,
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              trailing: Switch(
                value: isDarkMode,
                activeColor: Colors.purple[700],
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
      body:
          tasks.isEmpty
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.task_alt, size: 80, color: Colors.purple[300]),
                    SizedBox(height: 16),
                    Text(
                      strings['enter_plan']!,
                      style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                    ),
                  ],
                ),
              )
              : ListView.builder(
                padding: EdgeInsets.all(12),
                itemCount: tasks.length,
                itemBuilder: (_, i) {
                  final task = tasks[i];

                  return Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                    child: ListTile(
                      leading: Checkbox(
                        value: task.completed,
                        activeColor: Colors.purple[700],
                        onChanged: (val) {
                          setState(() {
                            task.completed = val!;
                          });
                        },
                      ),
                      title: Text(
                        task.title,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          decoration:
                              task.completed
                                  ? TextDecoration.lineThrough
                                  : null,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        icon: Icon(Icons.more_vert, color: Colors.purple[700]),
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
                                    Icon(
                                      Icons.play_circle,
                                      color: Colors.purple[700],
                                    ),
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
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        shape: CircleBorder(),
        child: Icon(Icons.add, size: 28),
      ),
    );
  }
}

class PomodoroPage extends StatefulWidget {
  final Task task;

  final Language lang;

  final int workTime;

  final int shortBreak;

  final int longBreak;

  final int sessionsBeforeLong;

  const PomodoroPage({
    required this.task,
    required this.lang,
    required this.workTime,
    required this.shortBreak,
    required this.longBreak,
    required this.sessionsBeforeLong,
  });

  @override
  State<PomodoroPage> createState() => _PomodoroPageState();
}

class _PomodoroPageState extends State<PomodoroPage>
    with SingleTickerProviderStateMixin {
  late int remainingSeconds;

  Timer? _timer;

  bool isRunning = false;

  bool isBreak = false;

  int currentSession = 1;

  late AnimationController _animationController;

  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _resetToWork();

    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  void _startTimer() {
    if (_timer != null) return;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          _timer?.cancel();

          _timer = null;

          _handleTimerEnd();
        }
      });
    });

    setState(() {
      isRunning = true;
    });

    _animationController.forward();
  }

  void _stopTimer() {
    _timer?.cancel();

    _timer = null;

    setState(() {
      isRunning = false;
    });

    _animationController.reverse();
  }

  void _resetTimer() {
    _stopTimer();

    setState(() {
      currentSession = 1;

      _resetToWork();
    });

    _animationController.reverse();
  }

  void _handleTimerEnd() {
    if (isBreak) {
      // Dam olish tugadi, keyingi ish sessiyasiga o'tish

      currentSession++;

      if (currentSession > widget.sessionsBeforeLong) {
        // Barcha sessiyalar tugadi

        isRunning = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(localizedStrings[widget.lang]!['pomodoro_complete']!),
            backgroundColor: Colors.purple[700],
          ),
        );

        return;
      }

      _resetToWork();
    } else {
      // Ish sessiyasi tugadi, dam olishga o'tish

      _resetToBreak();
    }

    if (isRunning) _startTimer(); // Avtomatik davom etish
  }

  void _resetToWork() {
    remainingSeconds = widget.workTime * 60;

    isBreak = false;
  }

  void _resetToBreak() {
    bool isLongBreak = (currentSession % widget.sessionsBeforeLong == 0);

    remainingSeconds =
        (isLongBreak ? widget.longBreak : widget.shortBreak) * 60;

    isBreak = true;
  }

  String _formatTime(int totalSeconds) {
    int minutes = totalSeconds ~/ 60;

    int seconds = totalSeconds % 60;

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();

    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var strings = localizedStrings[widget.lang]!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          strings['pomodoro_timer']!,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.purple[700],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.purple[900]!, Colors.purple[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.task.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              isBreak ? strings['break_time']! : strings['pomodoro_timer']!,
              style: TextStyle(color: Colors.white70, fontSize: 18),
            ),
            SizedBox(height: 20),
            ScaleTransition(
              scale: _animation,
              child: Container(
                padding: EdgeInsets.all(30),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white24, width: 2),
                ),
                child: Text(
                  _formatTime(remainingSeconds),
                  style: TextStyle(
                    fontSize: 72,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: isRunning ? _stopTimer : _startTimer,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    backgroundColor: Colors.purpleAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    isRunning ? 'Pause' : 'Start',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _resetTimer,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    backgroundColor: Colors.grey[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 4,
                  ),
                  child: Text(
                    'Reset',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
