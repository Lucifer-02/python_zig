const py = @cImport({
    @cDefine("PY_SSIZE_T_CLEAN", {});
    // @cInclude("python3.10/Python.h");
    @cInclude("Python.h");
});
const std = @import("std");
const print = std.debug.print;

const PyObject = py.PyObject;
const PyMethodDef = py.PyMethodDef;
const PyModuleDef = py.PyModuleDef;
const PyModuleDef_Base = py.PyModuleDef_Base;
const Py_BuildValue = py.Py_BuildValue; // create Python None value
const PyModule_Create = py.PyModule_Create;
const METH_NOARGS = py.METH_NOARGS;
const PyArg_ParseTuple = py.PyArg_ParseTuple;
const PyLong_FromLong = py.PyLong_FromLong;

fn zig_add(a: i64, b: i64) i64 {
    return a + b;
}

fn add(self: [*c]PyObject, args: [*c]PyObject) callconv(.C) [*]PyObject {
    _ = self;
    var a: c_long = undefined;
    var b: c_long = undefined;
    if (!(py._PyArg_ParseTuple_SizeT(args, "ll", &a, &b) != 0)) return Py_BuildValue("");
    return py.PyLong_FromLong(zig_add(a, b));
}

// Function to add two numbers
export fn add1(self: ?*py.PyObject, args: ?*py.PyObject) ?*py.PyObject {
    _ = self;
    var a: c_int = 0;
    var b: c_int = 0;

    // Parse the Python arguments (two integers)
    if (py.PyArg_ParseTuple(args, "ii", &a, &b) == 0) {
        return null;
    }

    // Return the result as a Python object
    return py.PyLong_FromLong(zig_add(a, b));
}

export fn sum_list(self: ?*PyObject, args: ?*PyObject) ?*PyObject {
    _ = self;
    var py_list: *PyObject = undefined;

    // Parse the argument
    if (PyArg_ParseTuple(args, "O", &py_list) == 0) {
        return null;
    }

    // Check if the object is a list
    if (py.PyList_Check(py_list) == 0) {
        py.PyErr_SetString(py.PyExc_TypeError, "Input must be a list");
        return null;
    }

    // Get the length of the list
    const length: py.Py_ssize_t = py.PyList_Size(py_list);

    var s: c_long = 0;
    var i: py.Py_ssize_t = 0;
    // Iterate through the list
    while (i < length) : (i += 1) {
        const item: *PyObject = py.PyList_GetItem(py_list, i);

        // Check if the item is an integer
        if (py.PyLong_Check(item) == 1) {
            s += py.PyLong_AsLong(item);
        }
    }

    // Return the result as a Python object
    return PyLong_FromLong(s);
}

export fn mul(self: ?*PyObject, args: ?*PyObject) ?*PyObject {
    _ = self;
    var a: c_long = undefined;
    var b: c_long = undefined;
    if (PyArg_ParseTuple(args, "ll", &a, &b) == 0) return Py_BuildValue("");
    return PyLong_FromLong((a * b));
}

export fn hello(self: ?*PyObject, args: ?*PyObject) ?*PyObject {
    _ = self;
    _ = args;
    print("Welcome to ziglang!!!\n", .{});

    return Py_BuildValue("");
}

export fn printSt(self: ?*PyObject, args: ?*PyObject) ?*PyObject {
    _ = self;
    var input: [*:0]u8 = undefined;
    if (PyArg_ParseTuple(args, "s", &input) == 0) return Py_BuildValue("");
    print("You entered: {s}\n", .{input});
    return Py_BuildValue("");
}

export fn returnArrayWithInput(self: ?*PyObject, args: ?*PyObject) ?*PyObject {
    _ = self;

    var N: u32 = undefined;
    if (!(py._PyArg_ParseTuple_SizeT(args, "l", &N) != 0)) return Py_BuildValue("");
    const list: ?*PyObject = py.PyList_New(N);

    var i: u32 = 0;
    while (i < N) : (i += 1) {
        const python_int: ?*PyObject = Py_BuildValue("i", i);
        _ = py.PyList_SetItem(list, i, python_int);
    }
    return list;
}

var Methods = [_]PyMethodDef{
    PyMethodDef{
        .ml_name = "sum_list",
        .ml_meth = sum_list,
        .ml_flags = py.METH_VARARGS,
        .ml_doc =
        \\sum(data)
        \\--
        \\
        \\Sum a list of integers
        ,
    },
    PyMethodDef{
        .ml_name = "add",
        .ml_meth = add,
        .ml_flags = py.METH_VARARGS,
        // .ml_doc = "add(a,b)\n--\n\nGreat example function",
        .ml_doc =
        \\add(a,b)
        \\--
        \\
        \\Calculation sum of 2 numbers
        ,
    },
    PyMethodDef{
        .ml_name = "add1",
        .ml_meth = add1,
        .ml_flags = py.METH_VARARGS,
        .ml_doc = "Add two numbers",
    },
    PyMethodDef{
        .ml_name = "mul",
        .ml_meth = mul,
        .ml_flags = py.METH_VARARGS,
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = "hello",
        .ml_meth = hello,
        .ml_flags = py.METH_NOARGS,
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = "printSt",
        .ml_meth = printSt,
        .ml_flags = py.METH_VARARGS,
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = "returnArrayWithInput",
        .ml_meth = returnArrayWithInput,
        .ml_flags = py.METH_VARARGS,
        .ml_doc = null,
    },
    PyMethodDef{
        .ml_name = null,
        .ml_meth = null,
        .ml_flags = 0,
        .ml_doc = null,
    },
};

var module = PyModuleDef{
    .m_base = PyModuleDef_Base{
        .ob_base = PyObject{
            .ob_refcnt = 1,
            .ob_type = null,
        },
        .m_init = null,
        .m_index = 0,
        .m_copy = null,
    },
    .m_name = "hoangdz",
    .m_doc = "experiment create python module in Zig",
    .m_size = -1,
    .m_methods = &Methods,
    .m_slots = null,
    .m_traverse = null,
    .m_clear = null,
    .m_free = null,
};

pub export fn PyInit_hoangdz() [*]PyObject {
    return PyModule_Create(&module);
}
