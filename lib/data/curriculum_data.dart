import '../models/course_model.dart';
import '../models/project_model.dart';

class SubjectCurriculum {
  final List<CourseModel> courses;
  final List<ProjectModel> projects;
  final Map<String, List<String>> projectRoadmaps; // Project ID -> List of steps

  SubjectCurriculum({
    required this.courses,
    required this.projects,
    required this.projectRoadmaps,
  });
}

class CurriculumData {
  static final Map<String, SubjectCurriculum> subjects = {
    'Programming Fundamentals': SubjectCurriculum(
      courses: [
        _course('pf_basic', 'Logic Building & Syntax', 'Master variables, loops, and conditions.', 'Programming Fundamentals', 'Beginner', '4 Weeks', '57347'),
        _course('pf_int', 'Functional Programming', 'Explore scope, closures, and modularity.', 'Programming Fundamentals', 'Intermediate', '6 Weeks', '57347'),
        _course('pf_exp', 'Concurrent Systems', 'High-performance multi-threading and memory.', 'Programming Fundamentals', 'Expert', '8 Weeks', '57347'),
      ],
      projects: [
        _project('pf_proj_1', 'Personal Finance CLI', 'A command-line tool to track expenses and generate reports.', 'Programming Fundamentals', 'Intermediate', '15 Hours', '59492', ['Dart', 'File I/O']),
      ],
      projectRoadmaps: {
        'pf_proj_1': [
          'Step 1: Define Transaction data models (amount, category, date).',
          'Step 2: Implement CLI input handler using stdin.',
          'Step 3: Add file-based persistence (JSON or CSV).',
          'Step 4: Implement basic math for monthly totals and spending spikes.',
        ],
      },
    ),
    'Data Structures & Algorithms': SubjectCurriculum(
      courses: [
        _course('dsa_basic', 'Linear Structures', 'Arrays, Linked Lists, Stacks, and Queues.', 'Data Structures & Algorithms', 'Beginner', '5 Weeks', '57347'),
        _course('dsa_int', 'Trees & Sorting', 'Heaps, BTS, and efficient sorting algorithms.', 'Data Structures & Algorithms', 'Intermediate', '8 Weeks', '57347'),
        _course('dsa_exp', 'Dynamic Programming', 'Master memoization and complex optimizations.', 'Data Structures & Algorithms', 'Expert', '10 Weeks', '57347'),
      ],
      projects: [
        _project('dsa_proj_1', 'Algorithm Visualizer', 'Interactive visualization of sorting and pathfinding.', 'Data Structures & Algorithms', 'Expert', '30 Hours', '61474', ['Flutter', 'Algorithms']),
      ],
      projectRoadmaps: {
        'dsa_proj_1': [
          'Step 1: Build a grid-based UI for graph or bar-chart for sorting.',
          'Step 2: Implement basic sorting logic (Bubble/Merge) with delayed updates.',
          'Step 3: Integrate A* or Dijkstra for pathfinding visualization.',
          'Step 4: Add controls for animation speed and custom inputs.',
        ],
      },
    ),
    'Computer Organization & Architecture': SubjectCurriculum(
      courses: [
        _course('coa_basic', 'Logic Gates & Circuits', 'Boolean algebra and combinational logic.', 'Computer Organization & Architecture', 'Beginner', '4 Weeks', '61559'),
        _course('coa_int', 'Processor Design', 'Build ALUs and understand instruction sets.', 'Computer Organization & Architecture', 'Intermediate', '8 Weeks', '61559'),
        _course('coa_exp', 'Parallel Computing', 'Cache coherence and superscalar design.', 'Computer Organization & Architecture', 'Expert', '8 Weeks', '61559'),
      ],
      projects: [
        _project('coa_proj_1', '8-Bit CPU Simulator', 'Software simulation of a simple CPU cycle.', 'Computer Organization & Architecture', 'Expert', '40 Hours', '61559', ['C++', 'Assembly']),
      ],
      projectRoadmaps: {
        'coa_proj_1': [
          'Step 1: Define virtual registers (ACC, PC, IR) and memory array.',
          'Step 2: Create an opcode mapper (ADD, SUB, JUMP).',
          'Step 3: Implement the Fetch-Decode-Execute loop.',
          'Step 4: Load a machine-code program and verify execution.',
        ],
      },
    ),
    'Operating Systems': SubjectCurriculum(
      courses: [
        _course('os_basic', 'OS Concepts', 'Process management and file systems.', 'Operating Systems', 'Beginner', '6 Weeks', '62621'),
        _course('os_int', 'Memory & Sync', 'Virtual memory, paging, and deadlocks.', 'Operating Systems', 'Intermediate', '8 Weeks', '62621'),
        _course('os_exp', 'Kernel Dev', 'Driver writing and microkernel design.', 'Operating Systems', 'Expert', '12 Weeks', '62621'),
      ],
      projects: [
        _project('os_proj_1', 'Custom Shell (Bash-like)', 'Unix-like shell with piping and redirection.', 'Operating Systems', 'Intermediate', '25 Hours', '61704', ['C', 'Unix API']),
      ],
      projectRoadmaps: {
        'os_proj_1': [
          'Step 1: Implement a command parser for string tokens.',
          'Step 2: Use fork() and execvp() for program execution.',
          'Step 3: Add I/O redirection using dup2().',
          'Step 4: Implement pipe support for multi-command chains.',
        ],
      },
    ),
    'Database Management Systems': SubjectCurriculum(
      courses: [
        _course('db_basic', 'SQL Foundations', 'ER diagrams and CRUD operations.', 'Database Management Systems', 'Beginner', '4 Weeks', '60134'),
        _course('db_int', 'Normalization', 'Indexing and transaction management (ACID).', 'Database Management Systems', 'Intermediate', '6 Weeks', '60134'),
        _course('db_exp', 'NoSQL Systems', 'Sharding, CAP theorem, and Replication.', 'Database Management Systems', 'Expert', '8 Weeks', '60134'),
      ],
      projects: [
        _project('db_proj_1', 'Mini SQL Engine', 'A simple database engine for flat files.', 'Database Management Systems', 'Expert', '35 Hours', '62347', ['Python', 'SQL']),
      ],
      projectRoadmaps: {
        'db_proj_1': [
          'Step 1: Create a table storage manager for fixed-record lengths.',
          'Step 2: Write a parser for basic SELECT/INSERT queries.',
          'Step 3: Implement an execution engine for filter logic.',
          'Step 4: Add basic B-Tree or Hash indexing.',
        ],
      },
    ),
    'Computer Networks': SubjectCurriculum(
      courses: [
        _course('net_basic', 'TCP/IP Basics', 'OSI model and subnetting.', 'Computer Networks', 'Beginner', '5 Weeks', '59449'),
        _course('net_int', 'Routing Protocols', 'OSPF, BGP, and congestion control.', 'Computer Networks', 'Intermediate', '8 Weeks', '59449'),
        _course('net_exp', 'SDN & Security', 'Software-defined networking and cryptography.', 'Computer Networks', 'Expert', '10 Weeks', '59449'),
      ],
      projects: [
        _project('net_proj_1', 'Multi-threaded Web Server', 'Raw socket-based server serving static HTML.', 'Computer Networks', 'Intermediate', '20 Hours', '61189', ['Rust', 'HTTP']),
      ],
      projectRoadmaps: {
        'net_proj_1': [
          'Step 1: Set up a TCP listener on a specific port.',
          'Step 2: Parse incoming HTTP GET requests manually.',
          'Step 3: Serve requested files from a local directory.',
          'Step 4: Add a thread pool to handle concurrent users.',
        ],
      },
    ),
    'Discrete Mathematics': SubjectCurriculum(
      courses: [
        _course('math_basic', 'Sets & Logic', 'Propositions, proofs, and set theory.', 'Discrete Mathematics', 'Beginner', '4 Weeks', '59424'),
        _course('math_int', 'Graph Theory', 'Combinatorics and probability.', 'Discrete Mathematics', 'Intermediate', '8 Weeks', '59424'),
        _course('math_exp', 'Cryptographic Math', 'Number theory and RSA algorithms.', 'Discrete Mathematics', 'Expert', '10 Weeks', '59424'),
      ],
      projects: [
        _project('math_proj_1', 'RSA Cryptographic Tool', 'Tool for key generation and secure messaging.', 'Discrete Mathematics', 'Expert', '25 Hours', '61664', ['Python', 'Math']),
      ],
      projectRoadmaps: {
        'math_proj_1': [
          'Step 1: Implement Sieve of Eratosthenes for large prime generation.',
          'Step 2: Built Extended Euclidean Algorithm for modular inverse.',
          'Step 3: Implement RSA key-pair generation (e, d, n).',
          'Step 4: Securely encrypt and decrypt text strings.',
        ],
      },
    ),
    'Software Engineering': SubjectCurriculum(
      courses: [
        _course('se_basic', 'SDLC Models', 'Waterfall, Agile, and requirements.', 'Software Engineering', 'Beginner', '4 Weeks', '61474'),
        _course('se_int', 'Testing & CI/CD', 'Unit tests and automated deployments.', 'Software Engineering', 'Intermediate', '6 Weeks', '61474'),
        _course('se_exp', 'System Design', 'Microservices and scalable architecture.', 'Software Engineering', 'Expert', '12 Weeks', '61474'),
      ],
      projects: [
        _project('se_proj_1', 'Agile Issue Tracker', 'Management system for bugs and tasks.', 'Software Engineering', 'Intermediate', '30 Hours', '60155', ['Flutter', 'Firebase']),
      ],
      projectRoadmaps: {
        'se_proj_1': [
          'Step 1: Design user roles (Assignee, Reporter, Project Lead).',
          'Step 2: Create a state-machine for issue status (Todo -> Done).',
          'Step 3: Build a Kanban dashboard with drag-and-drop.',
          'Step 4: Add progress charts and team performance metrics.',
        ],
      },
    ),
    'Theory of Computation': SubjectCurriculum(
      courses: [
        _course('toc_basic', 'Automata Basics', 'DFA/NFA and regular expressions.', 'Theory of Computation', 'Beginner', '6 Weeks', '61474'),
        _course('toc_int', 'Parsers & CFG', 'Context-free grammars and PDA.', 'Theory of Computation', 'Intermediate', '8 Weeks', '61474'),
        _course('toc_exp', 'Complexity Theory', 'Turing machines and NP-completeness.', 'Theory of Computation', 'Expert', '12 Weeks', '61474'),
      ],
      projects: [
        _project('toc_proj_1', 'Regex-to-NFA Compiler', 'Tool to convert regex into NFA graphs.', 'Theory of Computation', 'Expert', '40 Hours', '62744', ['Java', 'Compilers']),
      ],
      projectRoadmaps: {
        'toc_proj_1': [
          'Step 1: Write a Recursive Descent Parser for a regex sub-set.',
          'Step 2: Implement Thompson’s Construction for state transitions.',
          'Step 3: Export the result to DOT format for visualization.',
          'Step 4: Implement a string matching engine using the generated NFA.',
        ],
      },
    ),
    'Object-Oriented Programming': SubjectCurriculum(
      courses: [
        _course('oop_basic', 'Classes & Objects', 'Inheritance and encapsulation basics.', 'Object-Oriented Programming', 'Beginner', '4 Weeks', '59491'),
        _course('oop_int', 'Interfaces & Poly', 'Design by contract and polymorphic behavior.', 'Object-Oriented Programming', 'Intermediate', '6 Weeks', '59491'),
        _course('oop_exp', 'Design Patterns', 'SOLID principles and creational patterns.', 'Object-Oriented Programming', 'Expert', '10 Weeks', '59491'),
      ],
      projects: [
        _project('oop_proj_1', 'RPG Battle Simulator', 'A polymorphic engine for turn-based combat.', 'Object-Oriented Programming', 'Intermediate', '20 Hours', '62657', ['C#', 'SOLID']),
      ],
      projectRoadmaps: {
        'oop_proj_1': [
          'Step 1: Create an Abstract base class for Heroes and Enemies.',
          'Step 2: Use Interfaces for diverse abilities (Heal, Strike).',
          'Step 3: Implement Strategy pattern for different AI difficulty levels.',
          'Step 4: Use Factory pattern to generate random mob encounters.',
        ],
      },
    ),
  };

  static CourseModel _course(String id, String title, String desc, String cat, String diff, String dur, String ic) {
    return CourseModel(
      id: id,
      title: title,
      description: desc,
      category: cat,
      difficulty: diff,
      duration: dur,
      iconCode: ic,
      createdAt: DateTime.now(),
    );
  }

  static ProjectModel _project(String id, String title, String desc, String cat, String diff, String time, String ic, List<String> tech) {
    return ProjectModel(
      id: id,
      title: title,
      description: desc,
      category: cat,
      difficulty: diff,
      estimatedTime: time,
      iconCode: ic,
      technologies: tech,
      createdAt: DateTime.now(),
    );
  }
}
