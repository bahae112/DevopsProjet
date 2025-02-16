📊 **SonarQube Analysis Report**  
---  
### 📝 Issues Summary

**Total Issues: 8**  
- **Blocking: 2**  
- **Critical: 2**  
- **Major: 2**  
- **Minor: 3**  

### 🔍 Detected Issues

1. **Blocking**: Security vulnerability in user input handling on login form.
2. **Critical**: Code duplication found in the `calculateTotal()` method.
3. **Major**: Poor error handling in API data retrieval.
4. **Major**: Missing validation on user input in the registration form.
5. **Minor**: Undefined variable in the `processData()` function.
6. **Minor**: Incorrect date format in the `parseDate()` method.
7. **Minor**: Log messages containing sensitive information in production.
8. **Critical**: Hardcoded credentials in the authentication class.

### 🚨 Severity Levels

- **Blocking**: 2  
- **Critical**: 2  
- **Major**: 2  
- **Minor**: 3  

### 🧹 Code Smells

- **Unused variable**: The `tempData` variable in `dataProcessor.js` is not used anywhere.
- **Complex function**: The `calculateTotal()` method has too many lines of code, making it hard to maintain.
- **Long parameter list**: The `userDetails()` function has 6 parameters, consider refactoring.

### 📊 Duplications

- **Duplicated code in `calculateTotal()`**: This method has been copied across 3 different files, leading to maintenance issues.

### 🧪 Test Coverage

- **Overall coverage**: 85%  
- **Uncovered lines**: 15 lines in `api_handler.py` related to error handling.
- **Missing test for function**: `processData()` has no associated test case.
